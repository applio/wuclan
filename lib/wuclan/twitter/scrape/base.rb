require 'monkeyshines/scrape_request/raw_json_contents'
module Wuclan
  module Twitter
    module Scrape
      # Effectively unlimited request maximum
      # NO_LIMIT = 2**31
      NO_LIMIT = (50_000_000 / 100) # controlled insanity

      #
      # Base class for twitter API requests
      #
      class Base < TypedStruct.new(
          [:twitter_user_id,  Integer],
          [:page,             Integer],
          [:moreinfo,         String],
          [:url,              String],
          [:scraped_at,       Bignum],
          [:response_code,    Integer],
          [:response_message, String],
          [:contents,         String]
          )
        class_inheritable_accessor :resource_path, :page_limit, :max_items

        # Let us be peers with AFollowsB and TwitterUser and etc.
        include Wuclan::Twitter::Model
        # Contents are JSON
        include Monkeyshines::RawJsonContents
        # Requests are paginated
        include Monkeyshines::ScrapeJob::Paginated

        #
        def healthy?
          (! url.blank) && (            # has a URL and either:
            scraped_at.blank?        || # hasn't been scraped,
            (! response_code.blank?) || # or has, with response code
            (! contents.blank?) )       # or has, with response
        end

        # Generate request URL from other attributes
        def make_url
          # This works for most of the twitter calls
          "http://twitter.com/#{resource_path}/#{twitter_user_id}.json?page=#{page||1}"
        end

        # Characters to scrub from contents.
        # !! FIXME !! -- destructive.
        BAD_CHARS = { "\r" => "&#13;", "\n" => "&#10;", "\t" => "&#9;" }
        #
        # Set the contents from the fetch payload
        #
        def response= response
          self.contents = response.body.gsub(/[\r\n\t]/){|c| BAD_CHARS[c]}
        end

        #
        # Pagination
        #

        # creates the paginated request
        def request_for_page page, pageinfo=nil
          (page.to_i > 1) ? self.class.new(twitter_user_id, page) : self
        end

        # Number of items
        def num_items
          parsed_contents.length rescue 0
        end

        # if from_result has something to say about the max_total_items, fix the
        # value appropriately. (For example, a twitter_user's :statuses_count
        # sets the max_total_items for a TwitterUserTimelineRequest)
        def set_total_items from_result
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
