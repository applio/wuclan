require 'monkeyshines/scrape_request/raw_json_contents'
module Wuclan
  module Myspace
    module Scrape

      #
      # Application data
      #
      # The /v1 Appdata resources hold Application data in the form of key/value
      # pairs, where the key is an application parameter (which can vary from
      # one application to another) and the value is a valid one with respect to
      # the specified key. The key/value pair defines a subset of the full
      # information that it is possible to specify through the application's
      # parameters.
      
      # Returns application data.
      # http://wiki.developer.myspace.com/index.php?title=GET_v1_appdata_global
      class Request < Base             ; def make_url() "http://api.msappspace.com/v1/appdata/global.json" ;  end ; end
      
      # Returns all global application data for the specified list of keys.
      # http://wiki.developer.myspace.com/index.php?title=GET_v1_appdata_global_keys
      class Request < Base             ; def make_url() "http://api.msappspace.com/v1/appdata/global/{keys}.json" ;  end ; end
      
      # Returns key/value data for applications assigned to the friends of the user.
      # http://wiki.developer.myspace.com/index.php?title=GET_v1_users_userId_friends_appdata
      class Request < Base        ; def make_url() "http://api.msappspace.com/v1/users/{userId}/friends/appdata.json" ;  end ; end
      
      # Returns key/value data representing applications assigned to the user, when the userId and keys are specified.
      # http://wiki.developer.myspace.com/index.php?title=GET_v1_users_userId_appdata_keys
      class Request < Base             ; def make_url() "http://api.msappspace.com/v1/users/{userId}/appdata/{keys}.json" ;  end ; end

      #
      # Extended User Requests
      #
      
      # Returns mood information for the user specified by userId.
      # http://wiki.developer.myspace.com/index.php?title=GET_v1_users_userId_mood
      class Request < Base             ; def make_url() "http://api.msappspace.com/v1/users/{userId}/mood.json" ;  end ; end
      
      # Returns the list of moods for the user for the specified language. For a
      # listing of MySpace mood names, code numbers, & associated images in
      # alpha order by mood name, see myspace_mood_data_names_codes_images. This
      # list is useful when uploading/re-setting (Putting) mood data. Notice the
      # "s" in moods in the URL!
      # http://wiki.developer.myspace.com/index.php?title=GET_v1_users_userId_moods
      class Request < Base             ; def make_url() "http://api.msappspace.com/v1/users/{userId}/moods.json" ;  end ; end
      
      # Returns all of the specified user's preferences.
      # http://wiki.developer.myspace.com/index.php?title=GET_v1_users_userId_preferences
      class Request < Base             ; def make_url() "http://api.msappspace.com/v1/users/{userId}/preferences.json" ;  end ; end
      
      # Returns profile comments for the specified user.
      # http://wiki.developer.myspace.com/index.php?title=GET_v1_users_userId_comments
      class UserCommentsRequest < Base ; def make_url() "http://api.msappspace.com/v1/users/{userId}/comments.json" ;  end ; end
      
      # Returns status information for the user specified by userId.
      # http://wiki.developer.myspace.com/index.php?title=GET_v1_users_userId_status
      class UserStatusRequest < Base   ; def make_url() "http://api.msappspace.com/v1/users/{userId}/status.json" ;  end ; end
      
      # Returns the URL for indicators that are true (i.e., that are defined), suppresses tags for indicators that are false.
      # http://wiki.developer.myspace.com/index.php?title=GET_v1_users_userId_indicators
      class Request < Base             ; def make_url() "http://api.msappspace.com/Get_v1_users_userId_indicators.json" ;  end ; end

      # Retrieves data about friends of the user, as specified by userId, and particularly those friends specified in a friendlist. Optional parameters show mood, status, and online-status.
      # http://wiki.developer.myspace.com/index.php?title=GET_v1_users_userId_friendslist_show_mood_status_online
      class FriendsListRequest < Base        ; def make_url() "http://api.msappspace.com/v1/users/{userId}/friendslist/{friendId1;friendId2;friendId3...}.json?show=mood|status|online" ;  end ; end

    end
  end
end


