module Wuclan
  module Twitter
    module Scrape
      #
      # ScrapeRequest for the twitter Search API.
      #
      # Examines the parsed contents to describe result
      #
      class TwitterSearchRequest < Monkeyshines::ScrapeRequest
        # Contents are JSON
        include Monkeyshines::RawJsonContents
        # Pagination
        include Monkeyshines::ScrapeRequestCore::Paginated
        # API max items per response
        self.max_items     = 100
        # API max pages
        self.hard_request_limit = 15

        #
        #
        #
        def make_url
          "http://search.twitter.com/search.json?q=#{query_term}"
        end

        def query_term
          identifier
        end
        def key
          identifier
        end

        # Checks that the response parses and has the right data structure.
        # if healthy? is true things should generally work
        def healthy?
          items && items.is_a?(Array)
        end

        #
        # Rescheduling
        #

        # Extract the actual search items returned
        def items
          parsed_contents['results'] if parsed_contents
        end
        # Span of IDs. Assumes the response has the ids in sort order oldest to newest
        # (which the twitter API provides)
        def span
          [items.last['id'], items.first['id']] rescue nil
        end
        # Span of created_at times covered by this request.
        # Useful for rate estimation.
        def timespan
          [Time.parse(items.last['created_at']).utc, Time.parse(items.first['created_at']).utc] rescue nil
        end

      end
    end
  end
end

