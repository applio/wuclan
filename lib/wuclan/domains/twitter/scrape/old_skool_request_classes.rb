
module Wuclan::Domains::Twitter::Scrape
#
# Older versions of wuclan had a slightly different request naming scheme, and
# had additional specialized fields. This module adapts old to new; you're only
# likely to need this if you're me, @mrflip.
#
module OldSkoolRequest
  def initialize(priority, twitter_user_id, page, screen_name, *args) super(*args) ;
    self.twitter_user_id = twitter_user_id
  end
end
class Followers < TwitterFollowersRequest ; include OldSkoolRequest ; end
class Friends   < TwitterFriendsRequest   ; include OldSkoolRequest ; end
class Favorites < TwitterFavoritesRequest   ; include OldSkoolRequest ; end
class UserTimeline < TwitterUserTimelineRequest   ; include OldSkoolRequest ; end

end
