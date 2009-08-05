module Wuclan
  module Twitter
    module Scrape
      autoload :TwitterSearchRequest,  'wuclan/domains/twitter/scrape/twitter_search_request'
      autoload :TwitterSearchJob,      'wuclan/domains/twitter/scrape/twitter_search_job'

      autoload :Base,                         'wuclan/domains/twitter/scrape/base'
      autoload :TwitterUserRequest,           'wuclan/domains/twitter/scrape/twitter_user_request'
      autoload :TwitterFollowersRequest,      'wuclan/domains/twitter/scrape/twitter_followers_request'
      autoload :TwitterFriendsRequest,        'wuclan/domains/twitter/scrape/twitter_followers_request'
      autoload :TwitterFavoritesRequest,      'wuclan/domains/twitter/scrape/twitter_followers_request'
      autoload :TwitterFollowersIdsRequest,   'wuclan/domains/twitter/scrape/twitter_ff_ids_request'
      autoload :TwitterFriendsIdsRequest,     'wuclan/domains/twitter/scrape/twitter_ff_ids_request'
      autoload :TwitterUserTimelineRequest,   'wuclan/domains/twitter/scrape/twitter_timeline_request'
      autoload :TwitterPublicTimelineRequest, 'wuclan/domains/twitter/scrape/twitter_timeline_request'
      autoload :JsonUserWithTweet,            'wuclan/domains/twitter/scrape/twitter_json_response'
      autoload :JsonTweetWithUser,            'wuclan/domains/twitter/scrape/twitter_json_response'
    end
  end
end
