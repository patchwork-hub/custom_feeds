module CustomFeeds
  class FeedsController < Api::BaseController
    before_action -> { doorkeeper_authorize! :read, :'read:statuses' }, only: [:show]
    before_action :require_authenticated_user!
    include Authorization
    
    def show
      username = params[:username]

      @statuses = load_statuses
      @relationships = ::CustomFeedsStatusRelationshipsPresenter.new(@statuses, current_user&.account_id)

      render json: @statuses,
           each_serializer: REST::StatusSerializer,
           relationships: @relationships,
           status: account_home_feed.regenerating? ? 206 : 200
    end

    private

    def serialize_feed(items, username)
      {
        type: "Feed",
        username: username,
        items: items.map { |i| serialize_item(i) }
      }
    end

    def serialize_item(item)
      if item.respond_to?(:as_json)
        item.as_json
      else
        item
      end
    end

    def load_statuses
      preloaded_home_statuses
    end
  
    def preloaded_home_statuses
      preload_collection home_statuses, Status
    end
  
    def home_statuses
      account_home_feed.get(
        limit_param(DEFAULT_STATUSES_LIMIT),
        params[:max_id],
        params[:since_id],
        params[:min_id]
      )
    end
  
    def account_home_feed
      HomeFeed.new(current_account)
    end
  end
end
