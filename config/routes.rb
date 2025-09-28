CustomFeeds::Engine.routes.draw do
  get "@:username/feed", to: "feeds#show", as: :public_feed
  # get "@:username", to: "actors#show", as: :actor, defaults: { format: :json }
end
