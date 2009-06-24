module Wuclan
  module Models
    class UserGraphMetrics < Struct.new(
        :id,
        :any_with,
        :any_out_with,
        :any_in_with,
        #
        :fo_sampled,
        :fr_sampled,
        #
        :re_out_sampled,
        :re_in_sampled,
        #
        :at_out_sampled,
        :at_in_sampled,
        :at_out_with,
        :at_in_with,
        #
        :rt_out_sampled,
        :rt_in_sampled,
        :rt_out_with,
        :rt_in_with,
        #
        :fv_out_sampled,
        :fv_in_sampled,
        :fv_out_with,
        :fv_in_with
        )

      # ===========================================================================
      #
      # Graph Measures
      #

      #
      # Influx:
      #
      #   (messages/day) from all your n1
      #
      # This says how many messages you see go by in a day.
      #
      # A person with a massive influx is either not reading any tweets (uses
      # twitter as a podium), is dipping into twitter as a news river (we should
      # discount follow links), or is using a tool such as TweetDeck to fake
      # follow (we should more aggressively segregate their strong links)
      #
      def get_influx()
        #
      end

      #
      # tw_out_share -- Audience Share:
      #
      #   (your msgs out/day) / (Sum over n1o of msgs in / day)
      #
      # This says how much of your followers' attention is occupied by your tweet
      # stream
      #
      def get_tw_out_share()
        self.tw_out_share = twitter_user.tw_out_share
      end

      #
      # n1i_fv_share -- Sum, for all that favorite you, of
      #
      #   (favs to you / (max[20, number faved])
      #
      # if I have 12 faves and four are to you you get (4/20)favshare ; if I have
      # twenty-four, and four are to you, that makes a (1/6)favshare contribution.
      #
      def get_n1i_fv_share(  twitter_user)
        self.n1i_fv_share = twitter_user.n1i_fv_share
      end

      #
      # n1o_strong -- Strong links out
      #
      def get_n1o_strong(    twitter_user)
        self.n1o_strong = twitter_user.n1o_strong
      end

      #
      # n1i_strong -- Strong links in
      #
      def get_n1i_strong(    twitter_user)
        self.n1i_strong = twitter_user.n1i_strong
      end

      #
      # cluster_coeff -- Strong links between members of n1 over number of possible
      # links between members of n1
      #
      def cluster_coeff(twitter_user, multi_edge)
      end
    end

  end
end
