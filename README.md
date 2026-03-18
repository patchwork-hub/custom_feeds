# CustomFeeds

A Ruby gem that provides custom per-account timeline management for Mastodon-based social media platforms.

This gem extends Mastodon's feed system to support custom and "for you" timelines backed by Redis. It integrates with `FeedManager`, `FanOutOnWriteService`, and status removal services to provide seamless custom feed management for community admin accounts (boost bots).

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

- **Redis-backed Custom Feeds**: Per-account custom timelines stored in Redis with automatic trimming to 400 items
- **Push/Unpush Operations**: Add or remove statuses from custom timelines in real time via `push_to_custom` and `unpush_from_custom`
- **Timeline Population**: Build custom timelines from scratch using `populate_custom`
- **Merge/Unmerge Support**: Merge or remove an account's statuses from another account's custom timeline

### For You Timeline

- **Global Feed**: A single shared `feed:mix_channel_local_timeline` Redis key that aggregates local, public statuses
- **Auto-Managed**: Statuses are automatically added and removed via `after_create`/`after_destroy` callbacks on `Status`
- **Feature-Flagged**: Controlled by the `FOR_YOU_TIMELINE_ENABLED` environment variable

### Engine Integration

- **Concern Injection**: Integrates with the host Mastodon app via `include`/`prepend` — no direct modification of host classes
- **Boost-Bot Scoping**: Custom timelines are scoped to `ContentFilters::CommunityAdmin` accounts with `is_boost_bot: true`
- **Background Processing**: Uses `CustomFeedInsertWorker` (Sidekiq) with read-replica support for filtered status insertion
- **Real-Time Updates**: Pushes WebSocket updates via `PushUpdateWorker` on timeline changes

## API Endpoints

### Custom Feed Timelines

```
GET /api/v1/timelines/@:username/feed          # Retrieve custom feed for a boost-bot account
GET /api/v1/timelines/for_you_custom_timeline  # Retrieve the global "for you" feed
```

**Parameters:**

- `local` (boolean) - Show only local statuses
- `remote` (boolean) - Show only remote statuses
- `only_media` (boolean) - Show only statuses with media
- `limit` (integer) - Number of statuses to return
- `max_id` (string) - Return results older than this ID
- `since_id` (string) - Return results newer than this ID
- `min_id` (string) - Return results immediately newer than this ID

### Custom Boost Bot Status Management

```
POST /api/v1/custom_statuses/add_custom_boost_bot_status     # Manually add a status to a custom feed
POST /api/v1/custom_statuses/remove_custom_boost_bot_status  # Manually remove a status from a custom feed
```

## Configuration

### Environment Variables

- `FOR_YOU_TIMELINE_ENABLED` - Enable the global "for you" timeline; when set, local public statuses are automatically synced to `feed:mix_channel_local_timeline` in Redis (true or false, defaults to disabled)

### Dependencies

- **Redis**: Required for timeline storage
- **Sidekiq**: Required for background job processing
- **ContentFilters::CommunityAdmin**: Required model for identifying boost bot accounts

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/test` to run the tests. You can also use the dummy Rails application in `test/dummy` for development.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `lib/custom_feeds/version.rb`, and then run `bundle exec rake release`.

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/patchwork-hub/custom_feeds>. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/patchwork-hub/custom_feeds/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the CustomFeeds project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/patchwork-hub/custom_feeds/blob/main/CODE_OF_CONDUCT.md).
