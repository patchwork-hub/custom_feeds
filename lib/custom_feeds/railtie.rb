module CustomFeeds
  class Railtie < ::Rails::Railtie
    initializer "custom_feeds.configure" do |_app|
      # No-op: configuration lives in CustomFeeds::Configuration
    end
  end
end
