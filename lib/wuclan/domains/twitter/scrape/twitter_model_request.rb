module Wuclan
  module Domains
    module Twitter
      module Scrape

        # Effectively unlimited request maximum
        NO_LIMIT = 2**31

        #
        # Base class for twitter API requests
        #
        class Base
          class_inheritable_accessor :resource_path, :page_limit, :items_per_page
          attr_accessor  :identifier, :page

          # Contents are JSON
          include RawJsonContents

          #
          # Regular expression to grok resource from uri
          #                                resource_path  id  format          page           count
          GROK_URI_RE = %r{http://twitter.com/(\w+/\w+)/(\w+)\.json(?:\?page=(\d+))?(?:count=(\d+))?}
          #
          # Generate request URL
          #
          def url
            # This works for most of the twitter calls
            "http://twitter.com/#{resource_path}/#{identifier}.json?page=#{page}"
          end
        end

        #
        # API request for a user profile.
        #
        # Produces a TwitterUser,Profile,Style
        #
        # http://apiwiki.twitter.com/Twitter-REST-API-Method%3A-users%C2%A0show
        #
        class UserRequest         < Wuclan::Domains::Twitter::Scrape::Base
          self.resource_path   = 'users/show'
          self.page_limit      = 1
          self.items_per_page  = 1
          def items_count(thing) 1 end
        end

        #
        # API request for a user's status timeline.
        # Maximum 16 pages, 200 a pop.
        #
        # Produces up to 200 Tweets.
        #
        # http://apiwiki.twitter.com/Twitter-REST-API-Method%3A-statuses-user_timeline
        #
        class UserTimelineRequest  < Wuclan::Domains::Twitter::Scrape::Base
          self.resource_path  = 'statuses/user_timeline'
          self.page_limit     = 16
          self.items_per_page = 200
          def items_count(thing) thing.status_count end
          # This works for most of the twitter calls
          def url() "http://twitter.com/#{resource_path}/#{identifier}.json?page=#{page}&count=#{items_per_page}"  end
        end

        # Don't use this -- get hosebird access.
        class PublicTimelineRequest < Wuclan::Domains::Twitter::Scrape::Base
          self.resource_path  = 'statuses/public_timeline'
          self.page_limit     = 1
          self.items_per_page = 600
          def items_count(thing) 1 end
          def url() "http://twitter.com/#{resource_path}.json"  end
        end
        # class HosebirdRequest     < Wuclan::Domains::Twitter::Scrape::Base
        #   #self.resource_path = 'statuses/public_timeline'
        # end
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
