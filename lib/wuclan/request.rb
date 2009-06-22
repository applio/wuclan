module Wuclan
  class Request
    cattr_accessor :resource_path
    attr_accessor  :identifier, :page

    # Regular expression to grok resource from uri
    GROK_URI_RE = %r{http://twitter.com/(\w+/\w+)/(\w+)\.json\?page=(\d+)}

    #
    def url
      "http://twitter.com/#{resource_path}/#{identifier}.json?page=#{page}"
    end

    #
    # Threshold count-per-page and actual count to get number of expected pages.
    # Cap the request with max
    def self.pages_from_count per_page, count, max=nil
      num = [ (count.to_f / per_page.to_f).ceil, 0 ].max
      [num, max].compact.min
    end
  end

  class UserRequest < Wuclan::Request
    self.resource_path = 'users/show'
    def pages(thing) self.class.pages_from_count(200, thing.statuses_count,   20) end
  end
  class FollowersRequest < Wuclan::Request
    self.resource_path = 'statuses/followers'
    def pages(thing) self.class.pages_from_count(100, thing.followers_count,  10) end
  end
  class FriendsRequest < Wuclan::Request
    self.resource_path = 'statuses/friends'
    def pages(thing) self.class.pages_from_count(100, thing.friends_count,    10) end
  end
  class FavoritesRequest < Wuclan::Request
    self.resource_path = 'favorites'
    def pages(thing) self.class.pages_from_count( 20, thing.favourites_count, 20) end
  end
  class FollowersIdsRequest < Wuclan::Request
    self.resource_path = 'followers/ids'
    def pages(thing) thing.followers_count == 0 ? 0 : 1 end
    def url() "http://twitter.com/#{resource_path}/#{identifier}.json" end
  end
  class FriendsIdsRequest < Wuclan::Request
    self.resource_path = 'friends/ids'
    def pages(thing) thing.friends_count   == 0 ? 0 : 1 end
    def url() "http://twitter.com/#{resource_path}/#{identifier}.json"  end
  end
  class UserTimelineRequest < Wuclan::Request
    self.resource_path = 'statuses/user_timeline'
    def pages(thing) 1 end
    def url() "http://twitter.com/#{resource_path}/#{identifier}.json?page=#{page}&count=200"   end
  end
  class PublicTimelineRequest < Wuclan::Request
    self.resource_path = 'statuses/public_timeline'
    def pages(thing) 1 end
    def url() "http://twitter.com/#{resource_path}/#{identifier}.json"  end
  end
  # class HosebirdRequest < Wuclan::Request
  #   #self.resource_path = 'statuses/public_timeline'
  # end
  # class SearchRequest < Wuclan::Request
  #   def pages(thing) self.class.pages_from_count(100, 1500) end
  # end
end

# language: http://en.wikipedia.org/wiki/ISO_639-1
#
# * Find tweets containing a word:         http://search.twitter.com/search.atom?q=twitter
# * Find tweets from a user:               http://search.twitter.com/search.atom?q=from%3Aalexiskold
# * Find tweets to a user:                 http://search.twitter.com/search.atom?q=to%3Atechcrunch
# * Find tweets referencing a user:        http://search.twitter.com/search.atom?q=%40mashable
# * Find tweets containing a hashtag:      http://search.twitter.com/search.atom?q=%23haiku
# * Combine any of the operators together: http://search.twitter.com/search.atom?q=movie+%3A%29
#
# * lang:      restricts tweets to the given language, given by an ISO 639-1 code. Ex: http://search.twitter.com/search.atom?lang=en&q=devo
# * rpp:       the number of tweets to return per page, up to a max of 100. Ex: http://search.twitter.com/search.atom?lang=en&q=devo&rpp=15
# * page:      the page number (starting at 1) to return, up to a max of roughly 1500 results (based on rpp * page)
# * since_id:  returns tweets with status ids greater than the given id.
# * geocode:   returns tweets by users located within a given radius of the given latitude/longitude, where the user's location is taken from their Twitter profile. The parameter value is specified by "latitide,longitude,radius", where radius units must be specified as either "mi" (miles) or "km" (kilometers). Ex: http://search.twitter.com/search.atom?geocode=40.757929%2C-73.985506%2C25km. Note that you cannot use the near operator via the API to geocode arbitrary locations; however you can use this geocode parameter to search near geocodes directly.
# * show_user: when "true", adds "<user>:" to the beginning of the tweet. This is useful for readers that do not display Atom's author field. The default is "false".
