module Wuclan
  module Domains
    module Twitter
      module Scrape

        #
        # depending on the resource API responses can come back as either user,
        # with a contained tweet; or a tweet, with a contained user.
        #
        # also, sometimes this is a user+style+profile and sometimes a
        # user_partial.
        #
        # and sometimes the user's id is missing and has to be supplied from the
        # scrape_request.
        #
        # Finally, the record needs to be cleaned up and all that.
        #
        # This class handles all the complexity.
        #
        class HashOfUserAndTweet


          # Extracted JSON should be an array
          def healthy?()
            parsed_contents && parsed_contents.is_a?(Array)
          end

          def generate_relationship user, tweet
            case context
            when :followers then AFollowsB.new(  user.id,        owning_user_id)
            when :friends   then AFollowsB.new(  owning_user_id, user.id)
            when :favorites then AFavoritesB.new(owning_user_id, user.id, (tweet ? tweet.id : nil))
            else raise "Can't make a relationship out of #{context}. Perhaps better communication is the key."
            end
          end

          #
          # Enumerate over users (each having one tweet)
          #
          def each &block
            parsed_contents.each do |hsh|
              case context
              when :favorites then parsed = JsonTweet.new(      hsh, nil)
              else                 parsed = JsonTwitterUser.new(hsh, scraped_at)
              end
              next unless parsed && parsed.healthy?
              user_b = parsed.generate_user_partial
              tweet  = parsed.generate_tweet
              [ user_b,
                tweet,
                generate_relationship(user_b, tweet)
              ].compact.each do |obj|
                yield obj
              end
            end
          end
        end



        #
        # API request for the timeline from a user's followers.
        #
        # Produces max 100 TwitterUser,Profile,Style, their most recent Tweet,
        # and an AFollowsB link
        #
        # Before early 2009, produced TwitterUserPartials, not full records
        #
        # http://apiwiki.twitter.com/Twitter-REST-API-Method%3A-statuses%C2%A0followers
        #
        class FollowersRequest    < Wuclan::Domains::Twitter::Scrape::Base
          self.resource_path   = 'statuses/followers'
          self.page_limit      = NO_LIMIT
          self.items_per_page  = 100
          def items_count(thing) thing.followers_count end

          def parse &block
            parsed_contents.each do |hsh|
              #
              json_obj = JsonTwitterUser.new(hsh, scraped_at)
              next unless json_obj && json_obj.healthy?
              # Extract user, tweet and relationship
              user_b          = json_obj.extract_user
              tweet           = json_obj.extract_tweet
              relationship    = AFollowsB.new(user_b.id, self.twitter_user_id)
              #
              yield user_b       if user_b
              yield tweet        if tweet
              yield relationship if relationship
            end
          end
        end

        #
        # API request for the timeline from a user's friends.
        #
        # Produces max 100 TwitterUser,Profile,Style and their most recent Tweet
        #
        # Before early 2009, produced TwitterUserPartials, not full records
        #
        # http://apiwiki.twitter.com/Twitter-REST-API-Method%3A-statuses%C2%A0friends
        #
        class FriendsRequest      < Wuclan::Domains::Twitter::Scrape::Base
          self.resource_path  = 'statuses/friends'
          self.page_limit     = NO_LIMIT
          self.items_per_page = 100
          def items_count(thing) thing.friends_count end

          def parse &block
            parsed_contents.each do |hsh|
              #
              json_obj = JsonTwitterUser.new(hsh, scraped_at)
              next unless json_obj && json_obj.healthy?
              # Extract user, tweet and relationship
              user_b          = json_obj.extract_user
              tweet           = json_obj.extract_tweet
              relationship    = AFollowsB.new(self.twitter_user_id, user_b.id)
              #
              yield user_b       if user_b
              yield tweet        if tweet
              yield relationship if relationship
            end
          end
        end

        #
        # API request for the tweets favorited by the given user.  At 20 requests
        # per page, this is the worst bargain on the Twitter API call market.
        #
        # Produces max 20 TwitterUser,Profile,Style and the favorited Tweet.
        #
        # Before early 2009, produced TwitterUserPartials, not full records
        #
        # http://apiwiki.twitter.com/Twitter-REST-API-Method%3A-favorites
        #
        class FavoritesRequest    < Wuclan::Domains::Twitter::Scrape::Base
          self.resource_path  = 'favorites'
          self.page_limit     = NO_LIMIT
          self.items_per_page = 20
          def items_count(thing) thing.favourites_count end

          #
          # unpacks the
          #
          def parse &block
            parsed_contents.each do |hsh|
              #
              json_obj = JsonTweet.new(hsh) or next
              next unless json_obj && json_obj.healthy?
              #
              user_b       = json_obj.extract_user
              tweet        = json_obj.extract_tweet
              relationship = AFavoritesB.new(self.twitter_user_id, user_b.id, (tweet ? tweet.id : nil))
              #
              [user_b, tweet, relationship].flatten.compact.each{|obj| yield obj }
            end
          end
        end

      end
    end
  end
end
