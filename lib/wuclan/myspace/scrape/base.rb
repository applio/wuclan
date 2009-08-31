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
        class_inheritable_accessor :resource_path, :page_limit, :max_items
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
          "http://api.myspace.com/#{resource_path}/#{identifier}"
        end
      end

      # http://www.juicyfly.com/playground/myspace.php
      #http://www.throwingbeans.org/myspace_parser.html


      # Activities
      #
      # An activity stream is very important for driving behavior as it contains the latest trends and details about what users in your social graph are doing: updating photos, adding music to their profile, hosting events, making new friends, etc. The information available via this api is very rich. It is in fact, the same information we use to build the MySpace Home page and the MySpace Profile pages.
      #
      # Standards for Activity Streams
      # Activity Stream: Applications
      # Activity Stream: Events
      # Activity Stream: Music
      # Activity Stream: Notes
      # Activity Stream: People
      # Activity Stream: Photos
      # Activity Stream: Queries
      # Activity Stream: Videos
      #
      # See also: Activity Streams Category

      # Retrieves basic, full, or extended profile information about the user.
      # http://wiki.developer.myspace.com/index.php?title=GET_v1_users_userId_profile_basic_full_extended
      #
      # Basic Info: UserId, User URI, Display name, Web URI, Image URI, Large Image URI, User Type, Last Update Date
      # Full Info:  Profile URI, City, Region, Postal code, Country, Hometown, Age, Gender, Culture, About Me, Marital Status
      class UserRequest < Base
        def make_url() "http://api.myspace.com/v1/users/{userId}/profile.json?detailtype=[basic|full|extended]"
        end
      end

      #
      # Retrieves a list of friends of the user identified by the parameter
      # userId, and provides optional parameters:
      #
      # * selection criteria
      # * page-sorting
      # * friend-updates (mood, status, online)
      #
      # Parameters (All parameters are optional):
      #
      # * userId
      # * dateTime format (optional)
      # * list=[top|online|app|list]
      # * page=N
      # * page_size=[M|all]
      # * show=[mood|status|online]
      #
      # http://wiki.developer.myspace.com/index.php?title=GET_v1_users_userId_friends_list_page_show
      #
      class FriendsRequest < Base
        def make_url
          "http://api.myspace.com/v1/users/{userId}/friends.json?[list=top|online|app|list][&page=N][&page_size=M|all][&show=mood|status|online]"
        end
      end

      # Gets all the updates for a single user. Currently the activity types
      # included in this are the activities that the user has subscribed to.
      #
      # * All metadata is localized
      # * Uses UTC timestamps
      # * Unless you use the parameter "composite", each atom entry represents a single activity so partners can do their own aggregation.
      # * Unique ids
      #
      # Parameters:
      #
      # * userId
      # * culture(optional)
      # * datetime(optional)
      # * page_size(optional)
      # * activitytypes
      # * composite(true|false)
      # * extensions
      #
      # http://wiki.developer.myspace.com/index.php?title=Standards_for_Activity_Streams
      #
      class ActivitiesRequest < Base
        def make_url
          "http://api.myspace.com/v1/users/{userId}/activities.json"
        end
      end


      # This end point gets all the activities for the user's friends. The list
      # of activities includes the activities the users has subscribed to on
      # MySpace. The activities are sorted by date and time in descending
      # order. Consumers are responsible for exposing this information only to
      # the user passed in.
      #
      # Parameters:
      #
      # * userId
      # * culture(optional)
      # * datetime(optional)
      # * page_size(optional)
      # * activitytypes
      # * composite(true|false)
      # * extensions
      #
      # http://wiki.developer.myspace.com/index.php?title=Standards_for_Activity_Streams
      #
      class FriendsActivitiesRequest < Base
        def make_url
          "http://api.myspace.com/v1/users/{userId}/friends/activities.json"
        end
      end

    end
  end
end

