require 'monkeyshines/scrape_request/raw_json_contents'
require 'digest/md5'
module Wuclan
  module Friendster
    module Scrape
      Base = TypedStruct.new(
          [:identifier,       Integer],
          [:page,             Integer],
          [:moreinfo,         String],
          [:url,              String],
          [:scraped_at,       Bignum],
          [:response_code,    Integer],
          [:response_message, String],
          [:contents,         String]
          ) unless defined?(Base)
      #
      # Base class for Lastfm API requests
      #
      Base.class_eval do
        # Basic ScrapeRequest functionality
        include Monkeyshines::ScrapeRequestCore
        # Contents are JSON
        include Monkeyshines::RawJsonContents
        # Authenticates by URL
        include Monkeyshines::ScrapeRequestCore::SignedUrl
        # API
        cattr_accessor :api_key
        self.api_key = Monkeyshines::CONFIG[:api_key] rescue nil

        # Paginated
        class_inheritable_accessor :resource_path, :page_limit, :max_items
        # API
        cattr_accessor :api_key
        cattr_accessor :api_secret
        #
        def initialize *args
          super *args
          self.page = (page.to_i < 1 ? 1 : page.to_i)
          make_url! if (! url)
        end
        #
        # Generate request URL from other attributes
        def make_url
          "http://api.friendster.com/v1/#{resource_path}/#{identifier}#{resource_tail}"
        end
      end

      class TokenRequest < Base
        def make_url()
          authed_url("http://api.friendster.com/v1/token", {})
        end
      end

      class SessionRequest < Base
        def make_url(auth_token)
          authed_url("http://api.friendster.com/v1/session", { :auth_token => auth_token })
        end
      end



      class UserRequestB < Base
        def resource_path() "user"
        end
        def resource_tail()
          "?" # "profile?detailtype=extended"
        end
      end

      # /user                   GET     Get User Information for the logged in user.                    http://www.friendster.com/developer#userinfo
      # /user/:uids             GET     Get User Information for users in :uids list.                   .
      # /fans/:uid              GET     Get a fan profile's fan list.                                   .
      # /friends/:uid           GET     Get user's friend list.                                         .
      # /shoutout/:uids         GET     Get shoutouts for users in :uids list.                          .
      # /shoutout/              GET     Get the shoutout for the current user.                          .

      # users.getInfo
      # friends.get
      # notifications.get
    end
  end
end

