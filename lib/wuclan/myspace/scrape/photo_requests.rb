require 'monkeyshines/scrape_request/raw_json_contents'
module Wuclan
  module Myspace
    module Scrape

      # Returns photo albums of the user specified by userId parameter
      # http://wiki.developer.myspace.com/index.php?title=GET_v1_users_userId_albums
      class UserAlbumsRequest < Base ; def make_url() "http://api.msappspace.com/v1/users/{userId}/albums" ; end ; end

      # Returns all of the specified user's photos.
      # http://wiki.developer.myspace.com/index.php?title=GET_v1_users_userId_photos
      class Request < Base           ; def make_url() "http://api.msappspace.com/v1/users/{userId}/photos" ; end ; end
      
      # Returns videos for the user specified by userId.
      # http://wiki.developer.myspace.com/index.php?title=GET_v1_users_userId_videos
      class UserVideosRequest < Base ; def make_url() "http://api.msappspace.com/v1/users/{userId}/videos" ; end ; end
      
    end
  end
end
