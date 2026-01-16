# frozen_string_literal: true

module CustomFeeds::Concerns::StatusConcern
  extend ActiveSupport::Concern

  included do
    Rails.logger.info '>>>> Start staging testing log : StatusConcern'
    Rails.logger.info "check env FOR_YOU_TIMELINE_ENABLED : #{ENV['FOR_YOU_TIMELINE_ENABLED']}"
    if ENV['FOR_YOU_TIMELINE_ENABLED'].present? && ENV['FOR_YOU_TIMELINE_ENABLED']
      Rails.logger.info ">>>> staging test env FOR_YOU_TIMELINE_ENABLED : check after_create and after_destroy"
      after_create :add_status_to_mix_channel_local_timeline
      after_destroy :remove_status_from_mix_channel_local_timeline
    end
  end

  private

  def add_status_to_mix_channel_local_timeline
    Rails.logger.info '>>>> staging test Start after_create : add_status_to_mix_channel_local_timeline'
    Rails.logger.info ">>>> staging test self.local : #{self.local?}"
    if self.local?
      Rails.logger.info ">>>> staging test service call : CustomTimelineService#add_custom_public_status : #{self.id}"
      CustomFeeds::CustomTimelineService.new.add_custom_public_status(self.id)
    end
  end

  def remove_status_from_mix_channel_local_timeline
    Rails.logger.info '>>>> staging test Start after_destroy : remove_status_from_mix_channel_local_timeline'
    Rails.logger.info ">>>> staging test self.local : #{self.local?}"
    if self.local?
      Rails.logger.info ">>>> staging test service call : CustomTimelineService#remove_custom_public_status : #{self.id}"
      CustomFeeds::CustomTimelineService.new.remove_custom_public_status(self.id)
    end
  end
end
