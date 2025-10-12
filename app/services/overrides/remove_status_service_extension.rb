module Overrides::RemoveStatusServiceExtension
  
  def remove_from_followers
    @account.followers_for_local_distribution.includes(:user).reorder(nil).find_each do |follower|
      FeedManager.instance.unpush_from_home(follower, @status)
      FeedManager.instance.unpush_from_custom(follower, @status)
    end
  end
end