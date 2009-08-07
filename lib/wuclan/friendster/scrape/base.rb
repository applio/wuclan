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
        # Paginated
        class_inheritable_accessor :resource_path, :page_limit, :items_per_page
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

        def authed_url(session_key)
          qq = uri.query_values.merge(
            'api_key' => api_key, 'nonce' => nonce, 'session_key' => session_key, 'format' => 'json').sort.map{|k,v| k+'='+v }
          p qq
          str = [
            uri.path,
            qq,
            api_secret].flatten.join("")
          p str
          sig = Digest::MD5.hexdigest(str)
          qq << "sig=#{sig}"
          au = [uri.scheme, '://', uri.host, uri.path, '?', qq.join("&")].join("")
          p au
          au
        end
        def uri
          Addressable::URI.parse(url)
        end
        def nonce
          Time.now.utc.to_f.to_s
        end
      end

      class TokenRequest < Base
        def make_url
          "http://api.friendster.com/v1/token?api_key=#{api_key}&nonce=#{nonce}&format=json"
        end
        def authed_url
          qq = uri.query_values.merge(
            'api_key' => api_key,
            'nonce' => nonce,
            # 'auth_token' => auth_token,
            'format' => 'json').sort.map{|k,v| k+'='+v }
          p qq
          str = [
            uri.path,
            qq,
            api_secret].flatten.join("")
          p str
          sig = Digest::MD5.hexdigest(str)
          qq << "sig=#{sig}"
          au = [uri.scheme, '://', uri.host, uri.path, '?', qq.join("&")].join("")
          p au
          au
        end
      end

      class SessionRequest < Base
        def authed_url(auth_token)
          qq = uri.query_values.merge(
            'api_key' => api_key,
            'nonce' => nonce,
            'auth_token' => auth_token,
            'format' => 'json').sort.map{|k,v| k+'='+v }
          p qq
          str = [
            uri.path,
            qq,
            api_secret].flatten.join("")
          p str
          sig = Digest::MD5.hexdigest(str)
          qq << "sig=#{sig}"
          au = [uri.scheme, '://', uri.host, uri.path, '?', qq.join("&")].join("")
          p au
          au
        end
        def make_url()
          "http://api.friendster.com/v1/session?"
        end
      end

      # require 'monkeyshines' ; require 'wuclan' ; require 'wukong' ; require 'addressable/uri' ; require 'rest_client' ; scrape_config = YAML.load(File.open(ENV['HOME']+'/.monkeyshines'))
      # load(ENV['HOME']+'/ics/wuclan/lib/wuclan/friendster/scrape/base.rb') ; Wuclan::Friendster::Scrape::Base.api_key = scrape_config[:friendster_api][:api_key] ; tokreq = Wuclan::Friendster::Scrape::TokenRequest.new(scrape_config[:friendster_api][:user_id]) ; tok= RestClient.post(tokreq.authed_url, {}).gsub(/\"/,"")
      # sessreq = Wuclan::Friendster::Scrape::SessionRequest.new(scrape_config[:friendster_api][:user_id])
      # sessreq.auth_token = '' ; sessreq.make_url! ; RestClient.post(sessreq.url+'&sig='+sessreq.url_sig[1], {})
      # # => "{"session_key":"....","uid":"...","expires":"..."}"


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

