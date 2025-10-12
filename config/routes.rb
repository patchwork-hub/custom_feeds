CustomFeeds::Engine.routes.draw do
  get "@:username/feed", to: "feeds#show", as: :custom_feed
end
