require 'monkeyshines/scrape_request/raw_json_contents'
module Wuclan
  module Myspace
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
          self.page = (page.to_i < 1 ? 1 : page.to_i)
          make_url! if (! url)
        end
        #
        # Generate request URL from other attributes
        def make_url
          "http://api.friendster.com/v1/#{resource_path}/#{identifier}"
        end
      end
      

      class UserRequest < Base
        def make_url() "http://api.msappspace.com/v1/users/{userId}/profile.json?detailtype=[basic|full|extended]"
        end
      end

      # /user                   GET	Get User Information for the logged in user.			http://www.friendster.com/developer#userinfo
      # /user/:uids             GET     Get User Information for users in :uids list.			.
      # /fans/:uid              GET     Get a fan profile's fan list.					.
      # /friends/:uid           GET     Get user's friend list.						.
      # /shoutout/:uids         GET     Get shoutouts for users in :uids list.				.
      # /shoutout/              GET     Get the shoutout for the current user.				.
      
      # users.getInfo
      # friends.get
      # notifications.get
    end
  end
end

