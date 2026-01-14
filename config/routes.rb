CustomFeeds::Engine.routes.draw do
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      namespace :timelines do
        get "@:username/feed", to: "feeds#show", as: :custom_feed
        get "for_you_custom_timeline", to: "for_you_custom_timeline#show", as: :for_you_custom_timeline
      end
      namespace :custom_statuses do
        post "add_custom_boost_bot_status", to: "custom_boost_bot_status#add_custom_boost_bot_status", as: :add_custom_boost_bot_status
        post "remove_custom_boost_bot_status", to: "custom_boost_bot_status#remove_custom_boost_bot_status", as: :remove_custom_boost_bot_status
      end
    end
  end
end
