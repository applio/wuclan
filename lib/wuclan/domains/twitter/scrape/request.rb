module Wuclan
  module Domains
    module Twitter
      module Scrape
        #
        # ScrapeRequest for the twitter Search API.
        #
        # Examines the parsed contents to describe result
        #
        class TwitterSearchRequest < Monkeyshines::ScrapeRequest
          include Monkeyshines::RawJsonContents
          # Extract the actual search items returned
          def items
            parsed_contents['results'] if parsed_contents
          end
          # Checks that the response parses and has the right data structure.
          # if healthy? is true things should generally work
          def healthy?
            items && items.is_a?(Array)
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
end
