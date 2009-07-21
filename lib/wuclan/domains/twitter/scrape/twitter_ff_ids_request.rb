module Wuclan
  module Domains
    module Twitter
      module Scrape

        #
        # API request for the full list of a user's followers (IDs only).
        # One call gives the whole list.
        #
        # Produces a (possibly very large) number of AFollowsB.
        #
        class FollowersIdsRequest < Wuclan::Domains::Twitter::Scrape::Base
          self.resource_path  = 'followers/ids'
          self.page_limit     = 1
          self.items_per_page = NO_LIMIT
          def items_count(thing) thing.followers_count == 0 ? 0 : 1 end
          def url() "http://twitter.com/#{resource_path}/#{identifier}.json" end

          # followers_ids should be an array of user_ids
          def healthy?()
            parsed_contents && parsed_contents.is_a?(Array)
          end

          #
          # unpacks the raw API response, yielding all the relationships.
          #
          def each &block
            parsed_contents.each do |user_b_id|
              user_b_id = "%010d"%user_b_id.to_i
              # B is a follower: B follows user.
              yield AFollowsB.new(user_b_id, user_a_id)
            end
          end
        end

        #
        # API request for the full list of a user's friends (IDs only).
        # One call gives the whole list.
        #
        # Produces a (possibly very large) number of AFollowsB.
        #
        class FriendsIdsRequest   < Wuclan::Domains::Twitter::Scrape::Base
          self.resource_path  = 'friends/ids'
          self.page_limit     = 1
          self.items_per_page = NO_LIMIT
          def items_count(thing) thing.friends_count == 0 ? 0 : 1 end
          def url() "http://twitter.com/#{resource_path}/#{identifier}.json"  end

          #
          # friends_ids should be an array of user_id's
          #
          def healthy?()
            parsed_contents && parsed_contents.is_a?(Array)
          end

          #
          # unpacks the raw API response, yielding all the relationships.
          #
          def each &block
            parsed_contents.each do |user_b_id|
              user_b_id = "%010d"%user_b_id.to_i
              # B is a friend: user follows B
              yield AFollowsB.new(user_a_id, user_b_id)
            end
          end
        end

      end
    end
  end
end
