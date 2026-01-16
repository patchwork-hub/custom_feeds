# frozen_string_literal: true

module CustomFeeds::Concerns::StatusConcern
  extend ActiveSupport::Concern

  included do
    after_create :add_status_to_mix_channel_local_timeline, if: :for_you_timeline_enabled?
    after_destroy :remove_status_from_mix_channel_local_timeline, if: :for_you_timeline_enabled?
  end

  private

  def for_you_timeline_enabled?
    ActiveModel::Type::Boolean.new.cast(ENV['FOR_YOU_TIMELINE_ENABLED'])
  end

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
