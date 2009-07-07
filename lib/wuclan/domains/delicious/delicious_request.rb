module Wuclan
  module Delicious
    module DeliciousRequest
    end

    # Recent bookmarks by tag:                                                    http://feeds.delicious.com/v2/{format}/tag/{tag[+tag+...+tag]}
    # Popular bookmarks by tag:                                                   http://feeds.delicious.com/v2/{format}/popular/{tag}
    # Bookmarks for a specific user by tag(s):                                    http://feeds.delicious.com/v2/{format}/{username}/{tag[+tag+...+tag]}
    # Bookmarks for a specific user:                                              http://feeds.delicious.com/v2/{format}/{username}
    class TagRequest
      attr_accessor :scope
      def initialize scope
      end

      # pages
      # count
    end

    # A list of all public tags for a user:                                       http://feeds.delicious.com/v2/{format}/tags/{username}
    class UserTagsRequest
    end

    # Public summary information about a user (as seen in the network badge):     http://feeds.delicious.com/v2/{format}/userinfo/{username}
    class UserInfoRequest
    end

    # Recent bookmarks for a URL:                                                 http://feeds.delicious.com/v2/{format}/url/{url md5}
    class UrlInfoRequest
    end

    # A list of a user's network members:                                         http://feeds.delicious.com/v2/{format}/networkmembers/{username}
    class FollowersRequest
    end

    # A list of a user's network fans:                                            http://feeds.delicious.com/v2/{format}/networkfans/{username}
    class FriendsRequest
    end
  end
end


# Recent bookmarks by tag:                                                        http://feeds.delicious.com/v2/{format}/tag/{tag[+tag+...+tag]}
# Popular bookmarks by tag:                                                       http://feeds.delicious.com/v2/{format}/popular/{tag}
# Bookmarks for a specific user:                                                  http://feeds.delicious.com/v2/{format}/{username}
# Bookmarks for a specific user by tag(s):                                        http://feeds.delicious.com/v2/{format}/{username}/{tag[+tag+...+tag]}
# Public summary information about a user (as seen in the network badge):         http://feeds.delicious.com/v2/{format}/userinfo/{username}
# A list of all public tags for a user:                                           http://feeds.delicious.com/v2/{format}/tags/{username}
# Recent bookmarks for a URL:                                                     http://feeds.delicious.com/v2/{format}/url/{url md5}
# A list of a user's network members:                                             http://feeds.delicious.com/v2/{format}/networkmembers/{username}
# A list of a user's network fans:                                                http://feeds.delicious.com/v2/{format}/networkfans/{username}

# Bookmarks from the hotlist:                                                     http://feeds.delicious.com/v2/{format}
# Recent bookmarks:                                                               http://feeds.delicious.com/v2/{format}/recent
# Popular bookmarks:                                                              http://feeds.delicious.com/v2/{format}/popular
# Recent site alerts (as seen in the top-of-page alert bar on the site):          http://feeds.delicious.com/v2/{format}/alerts
# Bookmarks from a user's subscriptions:                                          http://feeds.delicious.com/v2/{format}/subscriptions/{username}
# Bookmarks from members of a user's network:                                     http://feeds.delicious.com/v2/{format}/network/{username}
# Bookmarks from members of a user's network by tag:                              http://feeds.delicious.com/v2/{format}/network/{username}/{tag[+tag+...+tag]}
# Summary information about a URL (as seen in the tagometer):                     http://feeds.delicious.com/v2/json/urlinfo/{url md5}

# Private bookmarks for a specific user:                                          http://feeds.delicious.com/v2/{format}/{username}?private={key}
# Private bookmarks for a specific user by tag(s):                                http://feeds.delicious.com/v2/{format}/{username}/{tag[+tag+...+tag]}?private={key}
# Private feed for a user's inbox bookmarks from others:                          http://feeds.delicious.com/v2/{format}/inbox/{username}?private={key}
# Bookmarks from members of a user's private network:                             http://feeds.delicious.com/v2/{format}/network/{username}?private={key}
# Bookmarks from members of a user's private network by tag:                      http://feeds.delicious.com/v2/{format}/network/{username}/{tag[+tag+...+tag]}?private={key}
