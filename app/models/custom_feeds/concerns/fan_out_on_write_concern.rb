# frozen_string_literal: true

module CustomFeeds::Concerns::FanOutOnWriteConcern
  extend ActiveSupport::Concern

  included do
    # Hook into the call method
    alias_method :original_call, :call
    
    def call(status, options = {})
      @options = options
      original_call(status, options)
      fan_out_to_custom_timeline!
    end
  end

  private

  def fan_out_to_custom_timeline!
    # Determine which accounts should receive this status in their custom timeline
    accounts = @options[:admin_accounts]
    target_accounts = Account.where(id: accounts)

    target_accounts.select(:id).reorder(nil).find_in_batches do |accounts|
      CustomFeedInsertWorker.push_bulk(accounts) do |account|
        [@status.id, account.id, { 'update' => update? }]
      end
    end
  end
end
