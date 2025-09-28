module CustomFeeds
  class Engine < ::Rails::Engine
    isolate_namespace CustomFeeds

    config.custom_feeds = ActiveSupport::OrderedOptions.new

    # Add presenters to autoload paths
    config.autoload_paths += %W(#{config.root}/app/presenters)

    initializer 'custom_feeds.load_routes' do |app|
      app.routes.prepend do
        mount CustomFeeds::Engine => "/", :as => :custom_feeds
      end
    end
  end
end
