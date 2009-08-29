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
        # Requests are paginated
        include Monkeyshines::ScrapeJob::Paginated

        #
        # API features
        #
        self.hard_request_limit = 15
        self.items_per_page     = 100

        #
        #
        #
        def make_url query_term, hsh
          url_str = "http://search.twitter.com/search.json?q=#{query_term}"
          url_str << "&rpp=#{items_per_page}"
          url_str << "&max_id=#{unscraped_span.max-1}" if unscraped_span.max
          url_str
        end

        def key
          query_term
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
        # Number of items returned in this request
        def num_items()
          items ? items.length : 0
        end
        # Span of IDs. Assumes the response has the ids in sort order oldest to newest
        # (which the twitter API provides)
        def span
          [items.last['id'], items.first['id']] rescue nil
        end
        # Span of created_at times covered by this request.
        # Useful for rate estimation.
        def timespan
          [Time.parse(items.last['created_at']), Time.parse(items.first['created_at'])] rescue nil
        end

      end
    end
  end
end

