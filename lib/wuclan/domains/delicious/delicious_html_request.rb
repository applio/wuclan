module Wuclan
  module Delicious
    module DeliciousRequest
    end

    # Recent bookmarks by tag:                                                    http://delicious.com/tag/{tag[+tag+...+tag]}?detail=3
    # Popular bookmarks by tag:                                                   http://delicious.com/popular/{tag}?detail=3
    # Bookmarks for a specific user by tag(s):                                    http://delicious.com/{username}/{tag[+tag+...+tag]}?detail=3
    # Bookmarks for a specific user:                                              http://delicious.com/{username}?detail=3
    class TagRequest
      attr_accessor :scope
      def initialize scope
      end

      # pages
      # count
    end

    # A list of all public tags for a user:                                       http://delicious.com/tags/{username}?view=all
    class UserTagsRequest
    end

    # Recent bookmarks for a URL:                                                 http://delicious.com/url/{url md5}
    class UrlInfoRequest
    end

    # A list of a user's network members:                                         http://delicious.com/network/{username}
    class FriendsFollowersRequest
    end
  end
end
