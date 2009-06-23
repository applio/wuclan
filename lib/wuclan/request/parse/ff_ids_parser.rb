module TwitterFriends
  module JsonModel

    # ===========================================================================
    #
    # Public timeline is an array of tweets => users
    #
    #
    class FfIdsParser < GenericJsonParser
      attr_accessor :scraped_at, :user_a_id, :context
      def initialize raw, context, scraped_at, user_a_id, *ignore
        super raw
        self.scraped_at = scraped_at
        self.context    = context
        self.user_a_id  = "%010d"%user_a_id.to_i
      end

      # friends_ids or followers_ids is an array of user_id's
      def healthy?() raw && raw.is_a?(Array) end
      def each &block
        raw.each do |user_b_id|
          user_b_id = "%010d"%user_b_id.to_i
          case context.to_s
          when 'followers_ids' then yield AFollowsB.new(user_b_id, user_a_id)
          when 'friends_ids'   then yield AFollowsB.new(user_a_id, user_b_id)
          end
        end
      end
    end
  end
end
