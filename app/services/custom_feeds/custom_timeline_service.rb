module CustomFeeds
  class CustomTimelineService < BaseService
    include Redisable

    # Maximum number of items stored in a single feed
    MAX_ITEMS = 400

    # set custom timeline key
    def timeline_key
      "feed:mix_channel_local_timeline"
    end

    # Trim a feed to maximum size by removing older items
    def trim
      redis.zremrangebyrank(timeline_key, 0, -(MAX_ITEMS + 1))
    end

    # from public status, add to mix_channel_local_timeline
    def add_custom_public_status(status_id)
      return unless status_id

      push_to_mix_channel_local_timeline(status_id)
      trim
    end

    # from public status, remove from mix_channel_local_timeline
    def remove_custom_public_status(status_id)
      return unless status_id

      unpush_from_mix_channel_local_timeline(status_id)
    end

    # Add a status to mix_channel_local_timeline
    def push_to_mix_channel_local_timeline(status_id)
      redis.zadd(timeline_key, status_id, status_id)
    end

    # Remove a status from mix_channel_local_timeline
    def unpush_from_mix_channel_local_timeline(status_id)
      redis.zrem(timeline_key, status_id)
    end
  end
end
