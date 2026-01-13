Rails.application.config.to_prepare do
  Status.include(CustomFeeds::Concerns::StatusConcern)
  FeedManager.include(CustomFeeds::Concerns::FeedManagerConcern)
  FanOutOnWriteService.include(CustomFeeds::Concerns::FanOutOnWriteConcern)
  RemoveStatusService.prepend(Overrides::RemoveStatusServiceExtension)
  BatchedRemoveStatusService.prepend(Overrides::BatchedRemoveStatusServiceExtension)
end
