require "singleton"

module CustomFeeds
  class Configuration
    include Singleton

    # attr_accessor :account_is_feed
    # attr_accessor :fetch_home_feed
    # attr_accessor :activitypub_actor

    # def initialize
    #   @account_is_feed = ->(_username) { false }
    #   @fetch_home_feed = ->(_username, _params) { [] }
    #   @activitypub_actor = nil
    # end
  end
end
