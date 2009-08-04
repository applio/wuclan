require 'monkeyshines/scrape_request/raw_json_contents'
module Wuclan
  module Lastfm
    module Scrape

      #
      # Base class for Lastfm API requests
      #
      class Base < TypedStruct.new(
          [:identifier,       Integer],
          [:page,             Integer],
          [:moreinfo,         String],
          [:url,              String],
          [:scraped_at,       Bignum],
          [:response_code,    Integer],
          [:response_message, String],
          [:contents,         String]
          )
        # Basic ScrapeRequest functionality
        include Monkeyshines::ScrapeRequestCore
        # Contents are JSON
        include Monkeyshines::RawJsonContents
        # Paginated
        class_inheritable_accessor :resource_path, :page_limit, :items_per_page
        # API
        cattr_accessor :api_key
        #
        def initialize *args
          super *args
          make_url! if (! url)
        end
        #
        # Generate request URL from other attributes
        def make_url
          # This works for most of the twitter calls
          "http://ws.audioscrobbler.com/2.0/?method=#{resource_path}&artist=#{identifier}&limit=100&page=#{page}&api_key=#{api_key}&format=json"
        end
      end

      class ArtistShoutsRequest
        self.resource_path = 'artist.getShouts'
      end
    end
  end
end
