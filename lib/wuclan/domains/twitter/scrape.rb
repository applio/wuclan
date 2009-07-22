module Wuclan
  module Domains
    module Twitter
      module Scrape
        autoload :TwitterSearchRequest,  'wuclan/domains/twitter/scrape/twitter_search_request'
        autoload :TwitterSearchJob,      'wuclan/domains/twitter/scrape/twitter_search_job'

        autoload :Base,                  'wuclan/domains/twitter/scrape/base'
        autoload :UserRequest,           'wuclan/domains/twitter/scrape/twitter_user_request'
        autoload :FollowersRequest,      'wuclan/domains/twitter/scrape/twitter_followers_request'
        autoload :FriendsRequest,        'wuclan/domains/twitter/scrape/twitter_followers_request'
        autoload :FavoritesRequest,      'wuclan/domains/twitter/scrape/twitter_followers_request'
        autoload :FollowersIdsRequest,   'wuclan/domains/twitter/scrape/twitter_ff_ids_request'
        autoload :FriendsIdsRequest,     'wuclan/domains/twitter/scrape/twitter_ff_ids_request'
        autoload :UserTimelineRequest,   'wuclan/domains/twitter/scrape/twitter_timeline_request'
        autoload :PublicTimelineRequest, 'wuclan/domains/twitter/scrape/twitter_timeline_request'
      end
    end
  end
end
