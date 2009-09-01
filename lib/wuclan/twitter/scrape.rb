module Wuclan
  module Twitter
    module Scrape
      # Search API
      autoload :TwitterSearchRequest,         'wuclan/twitter/scrape/twitter_search_request'
      autoload :TwitterSearchJob,             'wuclan/twitter/scrape/twitter_search_job'
      # Main API
      autoload :Base,                         'wuclan/twitter/scrape/base'
      autoload :TwitterUserRequest,           'wuclan/twitter/scrape/twitter_user_request'
      autoload :TwitterFollowersRequest,      'wuclan/twitter/scrape/twitter_followers_request'
      autoload :TwitterFriendsRequest,        'wuclan/twitter/scrape/twitter_followers_request'
      autoload :TwitterFavoritesRequest,      'wuclan/twitter/scrape/twitter_followers_request'
      autoload :TwitterFollowersIdsRequest,   'wuclan/twitter/scrape/twitter_ff_ids_request'
      autoload :TwitterFriendsIdsRequest,     'wuclan/twitter/scrape/twitter_ff_ids_request'
      autoload :TwitterUserTimelineRequest,   'wuclan/twitter/scrape/twitter_timeline_request'
      autoload :TwitterPublicTimelineRequest, 'wuclan/twitter/scrape/twitter_timeline_request'
      autoload :JsonUserWithTweet,            'wuclan/twitter/scrape/twitter_json_response'
      autoload :JsonTweetWithUser,            'wuclan/twitter/scrape/twitter_json_response'

    end
  end
end
autoload :TwitterRequestStream,         'wuclan/twitter/scrape/twitter_request_stream'
autoload :TwitterFakeFetcher,           'wuclan/twitter/scrape/twitter_fake_fetcher'
autoload :TwitterSearchRequestStream,   'wuclan/twitter/scrape/twitter_search_request_stream'
autoload :TwitterSearchFakeFetcher,     'wuclan/twitter/scrape/twitter_search_fake_fetcher'
