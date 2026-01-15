# frozen_string_literal: true

module CustomFeeds::Concerns::StatusConcern
  extend ActiveSupport::Concern

  included do
    if ENV['FOR_YOU_TIMELINE_ENABLED'].present? && ENV['FOR_YOU_TIMELINE_ENABLED'].to_s.downcase == 'true'
      after_create :add_status_to_mix_channel_local_timeline
      after_destroy :remove_status_from_mix_channel_local_timeline
    end
  end

  private

  def add_status_to_mix_channel_local_timeline
    if self.local?
      CustomFeeds::CustomTimelineService.new.add_custom_public_status(self.id)
    end
  end

  def remove_status_from_mix_channel_local_timeline
    if self.local?
      CustomFeeds::CustomTimelineService.new.remove_custom_public_status(self.id)
    end
  end
end
