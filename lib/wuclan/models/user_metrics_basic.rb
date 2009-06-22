#!/usr/bin/env ruby
require 'date'
# Executes only if run from command line
if __FILE__ == $0 then $: << File.dirname(__FILE__)+'/../..'; require 'wukong'; end

#
#
#
module TwitterFriends
  module StructModel
    class UserTweetMetrics < TypedStruct.new(
        [:id,                 Integer],
        [:tw_seen,            Integer],
        [:last_tw_at,         Bignum],
        [:tw_recent,          Integer]
        )
    end


    # 1 rsrc 2 id 3 screen_name 4protect 5 age 6duratio 7age_use 8age_las 9 fo
    # 10fr 11 tw 12 fv 13 fr_fo 14 fo_day 15 fr_day 16 tw_day 17 fv_day 18fo_seen
    # 19fr_seen 20tw_seen 21tw_rece 22tw_day_ 23at_in_s 24at_out_ 25rt_in_s
    # 26rt_out_ 27fv_in_s 28fv_out_ 29any_wit 30any_out 31any_in_ 32at_in_w
    # 33at_out_ 34rt_in_w 35rt_out_ 36fv_in_w 37fv_out_ 38at_tw_o 39rt_tw_o
    # 40rt_at_o 41at_in_t 42rt_in_t 43rt_at_i 44 reach 45fo_cove 46fr_cove
    # 47tw_cove 48fv_cove 49scrape_ 50scrape_ 51scrape_ 52 scraped_at
    # 53part_scraped_at 54 created_at 55 last_tw_at

    
        
    # [
    #     #
    #     [:fo_day,            Float],      #   x       Followers accumulated / day
    #     [:fr_day,            Float],      #   x       Friends   accumulated / day
    #     [:tw_day,            Float],      #   x       Tweets    sent / day
    #     [:fv_day,            Float],      #   x       Favorites accumulated / day
    #     #
    #     [:at_in_with,        Integer],    #       g   Users Atsigning you
    #     [:at_out_with,       Integer],    #       g
    #     [:rt_in_with,        Integer],    #       g   Users Retweeting you
    #     [:rt_out_with,       Integer],    #       g
    #     [:fv_in_with,        Integer],    #       g   Favorites by others of your tweets, with
    #     [:fv_out_with,       Integer],    #     c     Number of users who Favorited you
    #     #
    #     [:at_tw_out,         Float],      #       g   Atsigns  out per tweet out
    #     [:rt_tw_out,         Float],      #       g   Retweets out per tweet out
    #     [:rt_at_out,         Float],      #       g   Retweets out per  atsign out seen
    #     [:at_in_tw_out,      Float],      #       g   Atsigns  in  per tweet out
    #     [:rt_in_tw_out,      Float],      #       g   Retweets in  per tweet out
    #     [:rt_at_in,          Float],      #       g   Retweets in  seen per atsign in  seen
    #     #
    #     [:reach,             Integer],    #   x       Reach:   (your msgs/day) * |n1|
    # ]
    # [
    #     [:scraped_at,        Bignum],
    #     [:part_scraped_at,   Bignum],     #           Date of last user partial update
    #     #
    #     [:fo_coverage,       Float],      #     c     Friends seen   / known to exist
    #     [:fr_coverage,       Float],      #     c     Followers seen / known to exist
    #     [:tw_coverage,       Float],      #     c     Tweets seen    / known to exist
    #     [:fv_coverage,       Float],      #     c     Favorites seen / known to exist
    #     #
    #     [:fo_scraped_at,     Integer],      #     c     How long since your followers graph record was scraped
    #     [:fr_scraped_at,     Integer],      #     c     How long since your friends   graph record was scraped
    #     [:fv_scraped_at,     Integer],      #     c     How long since your favorites graph record was scraped
    #     #
    #   ]
    # 
    
    class UserMetrics < TypedStruct.new(
        [:id,                Integer],
        #
        [:created_at,        Bignum],
        [:last_tw_at,        Bignum],      #         t Date of the last seen tweet
        #
        [:fo,                Integer],
        [:fr,                Integer],
        [:tw,                Integer],
        [:fv,                Integer],
        #
        :n_followers_cat,
        :n_friends_cat,
        :n_tweets_cat,
        :active,
        
        [:any_with,          Integer],    #          Any graph link to
        :neighborhood_size,
        :friend_follower_balance
        )

      SCRAPING_DAY_ZERO_STR = 20081201000000
      SCRAPING_DAY_ZERO     = DateTime.parse(SCRAPING_DAY_ZERO_STR.to_s)
      SINCE_DAY_ZERO        = DateTime.now - SCRAPING_DAY_ZERO

      def to_a
        members.zip(mtypes).map do |member, type|
          val = self[member]
          next if val.nil?
          case
          when member.to_sym == :id     then "%010d"  % val.to_i
          when type == Float            then "%f"  % val.to_f
          when type == Integer          then "%7d"    % val.to_i
          when type == Bignum           then "%15s"   % val
          else val
          end
        end
      end
      def protected?
        protected.to_i == 1
      end

      #
      #
      #
      def user_adopted?
        @user_adopted
      end

      #
      #
      #
      def adopt_user user
        @user_adopted = true
        self.merge! user
      end

      #
      #
      #
      def adopt_user_partial user_partial
        user_scraped_at    = self.scraped_at
        self.merge! user_partial
        # restore scraped dates
        self.part_scraped_at = user_partial.scraped_at
        self.scraped_at      = user_scraped_at
      end

      #
      #
      #
      def adopt_scraping_metrics usm
        [
          [:friends_ids,   :scrape_age_fr, ],
          [:followers_ids, :scrape_age_fo, ],
          [:favorites,     :scrape_age_fv, ],
        ].each do |context, attr|
          dt = usm.get context, :scraped_at
          next if (usm.get(context, :successes).to_i < 1) || (dt.blank?)
          # fudge bogus date records
          dt = (dt.to_i < SCRAPING_DAY_ZERO_STR) ? SCRAPING_DAY_ZERO : DateTime.parse_safely(dt)
          next if dt.blank?
          self[attr] = now - dt
        end
      end

      #
      # From simple graph metrics
      #
      def adopt_graph_metrics user_graph_metrics
        self.merge! user_graph_metrics
      end

      #
      # User's Tweets -- from UserTweetMetrics
      #
      def adopt_tweet_metrics user_tweet_metrics
        self.tw_seen      = user_tweet_metrics.tw_seen
        self.last_tw_at   = user_tweet_metrics.last_tw_at
        self.tw_recent    = user_tweet_metrics.tw_recent
      end

      def followers_count=( fo) self.fo = fo.to_i end
      def friends_count=(   fr) self.fr = fr.to_i end
      def statuses_count=(  tw) self.tw = tw.to_i end
      def favourites_count=(fv) self.fv = fv.to_i end
      def followers_count()     self.fo end
      def friends_count()       self.fr end
      def statuses_count()      self.tw end
      def favourites_count()    self.fv end

      def crat
        @crat      ||= DateTime.parse_safely created_at
      end
      def scat
        @scat      ||= DateTime.parse_safely scraped_at
      end
      def part_scat
        @part_scat ||= DateTime.parse_safely part_scraped_at
      end
      def twat
        @twat      ||= DateTime.parse_safely last_tw_at
      end
      def now
        @now       ||= DateTime.now
      end

      #
      # duration --
      #
      def get_age()
        return unless crat
        self.age             = ( now - crat ).to_i
      end
      def get_duration()
        return unless crat && scat
        self.duration        = ( scat - crat ).to_i
      end
      def get_age_last_tw()
        return unless twat
        self.age_last_tw     = ( now - twat ).to_i
      end
      def get_age_user_scrape()
        return unless scat
        self.age_user_scrape = ( now - scat ).to_i
      end

      #
      # Per-day metrics
      #
      # Should possibly use duration but need to worry about which one.
      #
      def get_fo_day()    self.fo_day = (fo.to_f / age)  unless (age.to_i == 0) end
      def get_fr_day()    self.fr_day = (fr.to_f / age)  unless (age.to_i == 0) end
      def get_tw_day()    self.tw_day = (tw.to_f / age)  unless (age.to_i == 0) end
      def get_fv_day()    self.fv_day = (fv.to_f / age)  unless (age.to_i == 0) end
      def get_fr_fo()     self.fr_fo  = (fr.to_f / fo)        unless (fo.to_i       == 0) end
      def get_tw_day_recent()
        self.tw_day_recent = (tw.to_f / SINCE_DAY_ZERO)
      end

      #
      # Coverage: how many seen vs. how many known to exist.
      #
      def get_fo_coverage()  self.fo_coverage = (fo_seen.to_f     / fo) unless (fo.to_i == 0)  end
      def get_fr_coverage()  self.fr_coverage = (fr_seen.to_f     / fr) unless (fr.to_i == 0)  end
      def get_tw_coverage()  self.tw_coverage = (tw_seen.to_f     / tw) unless (tw.to_i == 0)  end
      def get_fv_coverage()  self.fv_coverage = (fv_out_seen.to_f / fv) unless (fv.to_i == 0)  end

      #
      # Conversational metrics:
      #   favorites, @atsigns and RT's per tweet, in and out
      #    RT per @atsign, in and out
      #
      def get_at_tw_out()    self.at_tw_out    = (at_out_seen.to_f / tw_seen.to_f)     unless (tw_seen.to_i == 0)  end
      def get_rt_tw_out()    self.rt_tw_out    = (rt_out_seen.to_f / tw_seen.to_f)     unless (tw_seen.to_i == 0)  end
      #
      def get_at_in_tw_out() self.at_in_tw_out = (at_in_seen.to_f  / tw_seen.to_f)     unless (tw_seen.to_i == 0)  end
      def get_rt_in_tw_out() self.rt_in_tw_out = (rt_in_seen.to_f  / tw_seen.to_f)     unless (tw_seen.to_i == 0)  end
      #
      def get_rt_at_out()    self.rt_at_out    = (rt_out_seen.to_f / at_out_seen.to_f) unless (at_out_seen.to_i == 0) end
      def get_rt_at_in()     self.rt_at_in     = (rt_in_seen.to_f  / at_in_seen.to_f)  unless (at_in_seen.to_i == 0)  end

      #
      # Reach:
      #
      #   (your msgs/day) * |n1|
      #
      # How many of your messages/day might get read. Audience Share (tw_out_share)
      # is a better measure of your impact.
      #
      def get_reach()
        self.get_tw_day or return
        self.reach = (tw_day.to_f * fo)
      end

    end
  end
end



#
# Executes only if run from command line
#
if __FILE__ == $0
  puts "rsrc\t"+TwitterFriends::StructModel::UserMetrics.members.join("\t")
end
