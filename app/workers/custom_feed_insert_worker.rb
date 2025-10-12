# frozen_string_literal: true

class CustomFeedInsertWorker
  include Sidekiq::Worker
  include DatabaseHelper

  def perform(status_id, account_id, options = {})
    with_primary do
      @status  = Status.find(status_id)
      @account = Account.find(account_id)
      @options = options.symbolize_keys
    end

    with_read_replica do
      check_and_insert
    end
  rescue ActiveRecord::RecordNotFound
    true
  end

  private

  def check_and_insert
    filter_result = FeedManager.instance.filter_from_custom?(@status, @account)

    if filter_result
      perform_unpush if update?
    else
      perform_push
    end

    # Add notification logic if needed
    # perform_notify if notify?
  end

  def perform_push
    FeedManager.instance.push_to_custom(@account, @status, update: update?)
  end

  def perform_unpush
    FeedManager.instance.unpush_from_custom(@account, @status, update: true)
  end

  def update?
    @options[:update]
  end
end