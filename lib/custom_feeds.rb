require "custom_feeds/version"
require "custom_feeds/railtie"
require "custom_feeds/engine"
require "custom_feeds/configuration"

module CustomFeeds
  class << self
    def configure
      yield(Configuration.instance)
    end

    def config
      Configuration.instance
    end
  end
end
