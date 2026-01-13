# CustomFeeds

A Rails engine that provides custom timeline functionality for Mastodon applications.

CustomFeeds extends Mastodon's feed system to support custom per-account timelines backed by Redis. It integrates with the existing FeedManager, FanOutOnWriteService, and status removal services to provide seamless custom feed management for community admin accounts (boost bots).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'custom_feeds', git: 'https://github.com/patchwork-hub/custom_feeds.git'
```

And then execute:

```bash
bundle install
```

## Features

### Custom Timeline Management
- **Redis-backed Custom Feeds**: Per-account custom timelines stored in Redis with automatic trimming
- **Push/Unpush Operations**: Add or remove statuses from custom timelines
- **Timeline Population**: Build custom timelines from scratch using `populate_custom`
- **Merge/Unmerge Support**: Merge or remove an account's statuses from another account's custom timeline

## API Endpoints

### Custom Feed Timeline
```
GET /api/v1/timelines/@:username/feed  # Retrieve custom feed for a community admin account
```

**Parameters:**
- `local` (boolean) - Show only local statuses
- `remote` (boolean) - Show only remote statuses
- `only_media` (boolean) - Show only statuses with media
- `limit` (integer) - Number of statuses to return
- `max_id` (string) - Return results older than this ID
- `since_id` (string) - Return results newer than this ID
- `min_id` (string) - Return results immediately newer than this ID

**Requirements:**
- The target account must be a community admin with `is_boost_bot: true` and active status

## Configuration

The engine uses a singleton configuration pattern. Configuration options can be set in an initializer:

```ruby
# config/initializers/custom_feeds.rb
CustomFeeds.configure do |config|
  # Configuration options (currently extensible via the Configuration class)
end
```

### Dependencies
- **Redis**: Required for timeline storage
- **Sidekiq**: Required for background job processing
- **ContentFilters::CommunityAdmin**: Required model for identifying boost bot accounts

## Architecture

### Engine Setup
The engine mounts at the root path and:
- Isolates its namespace to `CustomFeeds`
- Auto-loads presenters from `app/presenters`
- Prepends concerns to core Mastodon services via initializers

### Key Components

| Component | Purpose |
|-----------|---------|
| `CustomFeeds::CustomFeed` | Query interface for custom timelines |
| `FeedManagerConcern` | Extends FeedManager with custom timeline methods |
| `FanOutOnWriteConcern` | Hooks into status creation for custom feed distribution |
| `CustomFeedInsertWorker` | Async worker for filtered status insertion |

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/test` to run the tests. You can also use the dummy Rails application in `test/dummy` for development.

```bash
# Run tests
bin/test

# Run linter
bin/rubocop
```

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `lib/custom_feeds/version.rb`, and then run `bundle exec rake release`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/patchwork-hub/custom_feeds. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/patchwork-hub/custom_feeds/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the CustomFeeds project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/patchwork-hub/custom_feeds/blob/main/CODE_OF_CONDUCT.md).
