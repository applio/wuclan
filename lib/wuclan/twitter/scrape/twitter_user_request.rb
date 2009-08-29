module Wuclan
  module Twitter
    module Scrape

      #
      # API request for a user profile.
      #
      # Produces a TwitterUser,Profile,Style
      #
      # http://apiwiki.twitter.com/Twitter-REST-API-Method%3A-users%C2%A0show
      #
      #
      class TwitterUserRequest         < Wuclan::Twitter::Scrape::Base
        self.resource_path      = 'users/show'
        self.hard_request_limit = 1
        self.items_per_page     = 1
        def items_count(thing) 1 end

        # Extracted JSON should be a single user_with_tweet hash
        def healthy?()
          parsed_contents && parsed_contents.is_a?(Hash)
        end

        # Generate request URL
        def make_url
          "http://twitter.com/#{resource_path}/#{twitter_user_id}.json"
        end

        #
        # unpacks the raw API response, yielding all the interesting objects
        # and relationships within.
        #
        def parse *args, &block
          return unless healthy?
          json_obj = JsonUserWithTweet.new(parsed_contents, 'scraped_at' => scraped_at)
          next unless json_obj && json_obj.healthy?
          # Extract user and tweet
          json_obj.each(&block)
        end

      end
    end
  end
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
