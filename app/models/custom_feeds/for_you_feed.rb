# frozen_string_literal: true

class CustomFeeds::ForYouFeed
  include Redisable
  # @param [Account] account
  # @param [Hash] options
  # @option [Boolean] :with_reblogs
  # @option [Boolean] :local
  # @option [Boolean] :remote
  # @option [Boolean] :only_media
  # @option [Boolean] :grouped_admin_statuses
  # @option [Boolean] :exclude_direct_statuses
  # @option [Boolean] :exclude_replies
  def initialize(account, options = {})
    @account = account
    @options = options
  end

  # @param [Integer] limit
  # @param [Integer] max_id
  # @param [Integer] since_id
  # @param [Integer] min_id
  # @return [Array<Status>]
  def get(limit, max_id = nil, since_id = nil, min_id = nil)
    @status = custom_scope

    @status.merge!(without_replies_scope) if exclude_replies?
    @status.merge!(without_reblogs_scope) unless with_reblogs?
    @status.merge!(local_only_scope) if local_only?
    @status.merge!(remote_only_scope) if remote_only?
    @status.merge!(account_filters_scope) if account?
    @status.merge!(media_only_scope) if media_only?
    @status.merge!(media_only_scope) if media_only?
    @status.merge!(exclude_direct_statuses_scope) if exclude_direct_statuses?
    @status.merge!(grouped_admin_reblogged_statuses_scope) if grouped_admin_statuses?
    @status.merge!(language_scope) if account&.chosen_languages.present?

    @status.to_a_paginated_by_id(limit, max_id: max_id, since_id: since_id, min_id: min_id)
  end

  private

  attr_reader :account, :options

  def with_reblogs?
    options[:with_reblogs]
  end

  def exclude_replies?
    options[:exclude_replies]
  end

  def local_only?
    options[:local] && !options[:remote]
  end

  def remote_only?
    options[:remote] && !options[:local]
  end

  def account?
    account.present?
  end

  def media_only?
    options[:only_media]
  end

  def exclude_direct_statuses?
    options[:exclude_direct_statuses]
  end

  def custom_scope
    home_status_ids = redis.zrange(FeedManager.instance.key(:home, @account.id), 0, -1)
    mix_status_ids = redis.zrange("feed:mix_channel_local_timeline", 0, -1)
    merged_status_ids = home_status_ids + mix_status_ids
    @status = Status.where(id: merged_status_ids).joins(:account).merge(Account.without_suspended.without_silenced)
  end

  def local_only_scope
    @status = Status.local
  end

  def remote_only_scope
    @status = Status.remote
  end

  def without_replies_scope
    @status = Status.without_replies
  end

  def without_reblogs_scope
    @status = Status.without_reblogs
  end

  def media_only_scope
    @status = Status.joins(:media_attachments).group(:id)
  end

  def language_scope
    @status = Status.where(language: account.chosen_languages)
  end

  def account_filters_scope
    @status = Status.not_excluded_by_account(account).tap do |scope|
      scope.merge!(Status.not_domain_blocked_by_account(account)) unless local_only?
    end
  end

  def exclude_direct_statuses_scope
    @status = Status.where(visibility: %i(public unlisted))
  end

  def grouped_admin_statuses?
    options[:grouped_admin_statuses] && Status.column_names.include?('local_only')
  end

  def grouped_admin_statuses_scope
    grouped_admin_account_ids = fetch_grouped_admin_account_ids
    @status = Status.where.not(account_id: grouped_admin_account_ids)
  end

  def grouped_admin_reblogged_statuses_scope
    grouped_admin_account_ids = fetch_grouped_admin_account_ids
    grouped_admin_reblogged_ids = Status.where(account_id: grouped_admin_account_ids).pluck(:reblog_of_id).compact
    @status = Status.where.not(id: grouped_admin_reblogged_ids)
  end

  def fetch_grouped_admin_account_ids
    Rails.cache.fetch("grouped_admin_account_ids", expires_in: 1.hour) do
      ContentFilters::CommunityAdmin
        .includes(:community)
        .where(
          is_boost_bot: true,
          account_status: ContentFilters::CommunityAdmin.account_statuses[:active],
          community: { channel_type: ContentFilters::Community.channel_types[:channel_feed] }
        )
        .pluck(:account_id)
        .uniq
    end
  end
end
