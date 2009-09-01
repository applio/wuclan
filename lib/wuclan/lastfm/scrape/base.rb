require 'monkeyshines/scrape_request/raw_json_contents'
module Wuclan
  module Lastfm
    module Scrape

      #
      # Base class for Lastfm API requests
      #
      #
      # For parsing, note the different form for empty responses.
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
        # API Authentication
        cattr_accessor :api_key
        self.api_key = Monkeyshines::CONFIG[:api_key] rescue nil

        #
        # call with fields in order:
        #
        #    identifier page moreinfo url scraped_at response_code response_message contents
        #
        # you only have to fill in what you know -- in fact, it's typical to
        # pass in only the identifier
        def initialize *args
          super *args
          self.page = (page.to_i < 1 ? 1 : page.to_i)
        end

        # ===========================================================================
        #
        # API
        #

        # Slug for the URL to let lastfm know what resource is requested
        cattr_accessor :api_method
        # Responses are a JSON hash with one
        cattr_accessor :main_fieldname

        #
        # Generate request URL from other attributes
        #
        def make_url
          [ "http://ws.audioscrobbler.com/2.0/?method=#{api_method}#{identifier}",
            "&limit=#{max_items}&api_key=#{api_key}&format=json",
            "&page=#{page}" ].join("")
        end

        #
        # Call with a hash of identifier attr-val pairs (including an optional page)
        #
        # Ex.
        #     LastfmAlbumInfoRequest.from_identifier_hash(
        #       :album => 'Rum+Sodomy+%26+the+Lash',
        #       :artist => 'The+Pogues',
        #       :mbid => 'ba1f6641-9085-36a0-8962-65ad6e48afd1')
        # Calls
        #     LastfmAlbumInfoRequest.new(
        #       'album=Rum+Sodomy+%26+the+Lash&artist=The+Pogues&mbid=ba1f6641-9085-36a0-8962-65ad6e48afd1')
        #
        # FIXME -- this is stupid in taking a special 'id' and a just-as-necessary hash
        #
        def self.from_identifier_hash name, hsh={}
          name = url_encode(name)
          page = hsh.delete(:page)
          rest = self.class.make_url_query(hsh)
          new("#{name}&#{rest}", page)
        end

        # ===========================================================================
        #
        # Parsing
        #

        # Healthy if it's well-formed and not an error
        def healthy?
          super && ( (contents !~ %r{^\{"error":}) )
        end

        #
        # Last.fm responses typically have the form
        #
        #   { "requested_objs": {
        #       "requested_type": [ { ... obj ... }, { ... obj ... } ... ],
        #       "@attr":{ "key": "val" }
        #     }
        #   }
        #
        # e.g.
        #
        #   {"similarartists":{
        #      "artist": [
        #        ...
        #        {"name":"Pillar","mbid":"..","match":"5.66",..."streamable":"1"}],
        #     "@attr":{"artist":"Dead by Sunrise"}
        #     }}
        #
        def main_result
          return @main_result if @main_result
          return unless healthy?
          @main_result = parsed_contents[main_fieldname] rescue {}
        end

        #
        # Information about the request itself.
        #
        # (see doc for result_attrs)
        def result_attrs
          main_result["@attr"] rescue {}
        end

        # Extract the actual search items returned
        def items
          # [obj_or_array].flatten makes this always be an array (lastfm gives
          # the single object when it's not an array)
          [main_result[response_type]].flatten.compact rescue []
        end

        #
        # Pagination and Rescheduling
        #
        # Pagination
        include Monkeyshines::ScrapeRequestCore::Paginated
        include Monkeyshines::ScrapeRequestCore::Paginating
        include Monkeyshines::ScrapeRequestCore::PaginatedWithLimit
        # include Monkeyshines::ScrapeRequestCore::PaginatedWithRate

        # API max items per response
        self.max_items = 50
        # API max pages
        self.hard_request_limit = 15
        # Items to get each re-visit. If there are up to 50 items per page,
        # target_items_per_job of 1000 will try to reschedule so that its return visit
        # makes about twenty page requests.
        # #self.target_items_per_job = 150

        # creates the paginated request
        def request_for_page page, pageinfo=nil
          (page.to_i > 1) ? self.class.new(identifier, page) : self
        end

        #
        # Max pages for this resource
        #
        def max_pages
          return 1 if (result_attrs.blank? || result_attrs['totalPages'].blank?)
          attrs['totalPages'].to_i.clamp(1,self.hard_request_limit)
        end

        #
        # For stream-type objects
        #

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

        class_inheritable_accessor :requestables
        self.requestables = []
        def recursive_requests &block
          return unless healthy?
          #
          # requestables
          #
          requestables.each do |klass|
            req = klass.new(identifier)
            req.generation = generation.to_i + 1
            yield req
          end
        end
      end

    end
  end
end
