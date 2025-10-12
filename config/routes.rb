CustomFeeds::Engine.routes.draw do
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      namespace :timelines do
        get "@:username/feed", to: "feeds#show", as: :custom_feed
      end
    end
  end
end
