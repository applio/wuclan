module Wuclan
  module Domains
    module Twitter
      module Scrape
        autoload :TwitterSearchRequest,  'wuclan/domains/twitter/scrape/twitter_search_request'
        autoload :TwitterSearchJob,      'wuclan/domains/twitter/scrape/twitter_search_job'
        autoload :UserRequest,           'wuclan/domains/twitter/scrape/twitter_model_request'
        autoload :FollowersRequest,      'wuclan/domains/twitter/scrape/twitter_model_request'
        autoload :FriendsRequest,        'wuclan/domains/twitter/scrape/twitter_model_request'
        autoload :FavoritesRequest,      'wuclan/domains/twitter/scrape/twitter_model_request'
        autoload :FollowersIdsRequest,   'wuclan/domains/twitter/scrape/twitter_model_request'
        autoload :FriendsIdsRequest,     'wuclan/domains/twitter/scrape/twitter_model_request'
        autoload :UserTimelineRequest,   'wuclan/domains/twitter/scrape/twitter_model_request'
        autoload :PublicTimelineRequest, 'wuclan/domains/twitter/scrape/twitter_model_request'

        # autoload :UserRequest,           'wuclan/domains/twitter/scrape/user_request'
        # autoload :FollowersRequest,      'wuclan/domains/twitter/scrape/followers_request'
        # autoload :FriendsRequest,        'wuclan/domains/twitter/scrape/friends_request'
        # autoload :FavoritesRequest,      'wuclan/domains/twitter/scrape/favorites_request'
        # autoload :FollowersIdsRequest,   'wuclan/domains/twitter/scrape/followers_ids_request'
        # autoload :FriendsIdsRequest,     'wuclan/domains/twitter/scrape/friends_ids_request'
        # autoload :UserTimelineRequest,   'wuclan/domains/twitter/scrape/user_timeline_request'
        # autoload :PublicTimelineRequest, 'wuclan/domains/twitter/scrape/public_timeline_request'
      end
    end
  end
end
