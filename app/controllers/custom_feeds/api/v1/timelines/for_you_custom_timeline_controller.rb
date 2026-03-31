module CustomFeeds::Api::V1::Timelines
  class ForYouCustomTimelineController < Api::V1::Timelines::BaseController
    before_action -> { doorkeeper_authorize! :read, :'read:statuses' }
    before_action :require_user!

    PERMITTED_PARAMS = %i(local remote limit only_media grouped_admin_statuses).freeze

    def show
      cache_if_unauthenticated!
      @statuses = load_statuses
      render json: @statuses, each_serializer: REST::StatusSerializer, relationships: StatusRelationshipsPresenter.new(@statuses, current_user&.account_id)
    end

    private

    def load_statuses
      preloaded_for_you_statuses_page
    end

    def preloaded_for_you_statuses_page
      preload_collection(for_you_statuses, Status)
    end

    def for_you_statuses
      foryou_feed.get(
        limit_param(DEFAULT_STATUSES_LIMIT),
        params[:max_id],
        params[:since_id],
        params[:min_id],
      )
    end

    def foryou_feed
      CustomFeeds::ForYouFeed.new(
        current_account,
        local: truthy_param?(:local),
        remote: truthy_param?(:remote),
        only_media: truthy_param?(:only_media),
        grouped_admin_statuses: truthy_param?(:grouped_admin_statuses)
      )
    end

    def next_path
      api_v1_timelines_for_you_custom_timeline_url next_path_params
    end

    def prev_path
      api_v1_timelines_for_you_custom_timeline_url prev_path_params
    end
  end
end