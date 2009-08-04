module Wuclan
  module Domains
    module Twitter
      module Scrape

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
        class TwitterFollowersRequest    < Wuclan::Domains::Twitter::Scrape::Base
          self.resource_path   = 'statuses/followers'
          self.page_limit      = NO_LIMIT
          self.items_per_page  = 100
          def items_count(thing) thing.followers_count end

          # Extracted JSON should be an array
          def healthy?()
            parsed_contents && parsed_contents.is_a?(Array)
          end

          #
          # unpacks the raw API response, yielding all the interesting objects
          # and relationships within.
          #
          def parse *args, &block
            return unless healthy?
            parsed_contents.each do |hsh|
              json_obj = JsonUserWithTweet.new(hsh, 'scraped_at' => scraped_at)
              next unless json_obj && json_obj.healthy?
              #
              # Extract user, tweet and relationship
              yield AFollowsB.new(json_obj.user.id, self.twitter_user_id) if json_obj.user
              json_obj.each(&block)
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
        class TwitterFriendsRequest      < Wuclan::Domains::Twitter::Scrape::Base
          self.resource_path  = 'statuses/friends'
          self.page_limit     = NO_LIMIT
          self.items_per_page = 100
          def items_count(thing) thing.friends_count end

          # Extracted JSON should be an array
          def healthy?()
            parsed_contents && parsed_contents.is_a?(Array)
          end

          #
          # unpacks the raw API response, yielding all the interesting objects
          # and relationships within.
          #
          def parse *args, &block
            return unless healthy?
            parsed_contents.each do |hsh|
              json_obj = JsonUserWithTweet.new(hsh, 'scraped_at' => scraped_at)
              next unless json_obj && json_obj.healthy?
              #
              # Extract user, tweet and relationship
              yield AFollowsB.new(self.twitter_user_id, json_obj.user.id) if json_obj.user
              json_obj.each(&block)
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
        class TwitterFavoritesRequest    < Wuclan::Domains::Twitter::Scrape::Base
          self.resource_path  = 'favorites'
          self.page_limit     = NO_LIMIT
          self.items_per_page = 20
          def items_count(thing) thing.favourites_count end

          # Extracted JSON should be an array
          def healthy?()
            parsed_contents && parsed_contents.is_a?(Array)
          end

          #
          # unpacks the raw API response, yielding all the interesting objects
          # and relationships within.
          #
          def parse *args, &block
            return unless healthy?
            parsed_contents.each do |hsh|
              json_obj = JsonTweetWithUser.new(hsh, 'scraped_at' => scraped_at)
              next unless json_obj && json_obj.healthy?
              #
              # Extract user, tweet and relationship
              yield AFavoritesB.new(self.twitter_user_id, json_obj.user.id, json_obj.tweet.id) if json_obj.user && json_obj.tweet
              json_obj.each(&block)
            end
          end
        end

      end
    end
  end
end
