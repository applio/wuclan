module Wuclan
  module JsonModel

    # ===========================================================================
    #
    # Public timeline is an array of tweets => users
    #
    #
    class FfIdsParser < GenericJsonParser

      # friends_ids or followers_ids is an array of user_id's
      def healthy?()
        contents && contents.is_a?(Array)
      end

      def each &block
        contents.each do |user_b_id|
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
