#!/usr/bin/env ruby
require 'date'
# KLUDGE Executes only if run from command line
if __FILE__ == $0 then $: << File.dirname(__FILE__)+'/../..'; require 'wukong'; end

#
# Sampling Multiplier
#
TWEETS_SAMPLED_FRACTION = 2.62


require 'wukong/datatypes/enum'; include Wukong::Datatypes
class FoBin           < Binned    ; enumerates 0, 0, 2, 5, 10, 20, 50, 100, 200, 500, 1000, 2000, 5000, 10_000, 20_000, Infinity ;end
class FrBin           < FoBin     ; end
class NbhdSizeBin     < FoBin     ; end

def round1 f
  (10 * f.to_f).round / 10.0
end
def octave3 i
  10.0 ** round1(i.to_f / 3.0)
end

class TwDayBin       < Binned    ;
  MO = 30.4368499
  WK =  7.0
  enumerates(* (
    [-Infinity, 1.0 / MO, 2.0 / MO,   1 / WK, ] +
    (-2 .. 9).map{|i| octave3(i + 0.5) } +
    [Infinity]))
  self.write_inheritable_attribute :names, (
    ['<    1/mo', '   1-2/mo', '     2/mo-1/wk', '   1-2/wk', '~    4/wk' ] +
    [1, 2, 5, 10, 20, 50, 100, 200, 500, 1000].map{|i| "~ %4d/day"%i } +
    ['> 1500/day'])
end
class TwDayRecentBin < TwDayBin ; end

# <    1/mo                                       0.032854911177914
#      1-2/mo                                     0.065709822355828
#      2/mo-1/wk                                  0.142857142857143
#      1-2/wk                                     0.316227766016838
# ~    4/wk                                       0.630957344480193
# ~    1/day                                      1.58489319246111
# ~    2/day                                      3.16227766016838
# ~    5/day                                      6.30957344480193
# ~   10/day                                      15.8489319246111
# ~   20/day                                      31.6227766016838
# ~   50/day                                      63.0957344480193
# ~  100/day                                      158.489319246111
# ~  200/day                                      316.227766016838
# ~  500/day                                      630.957344480193
# ~ 1000/day                                      1584.89319246111
# > 1500/day                                      Infinity


class TinyInt         < Integer   ; end
class NbhdBalBin      < Binned
  enumerates(* ([-Infinity] + ( (0..15).map{|n| (0.125+(n.to_f/20))} ) + [Infinity]) )
  self.write_inheritable_attribute :names,
    (['Few followers'] + (0..14).map{|n| (15+(5*n)) } + ['Mostly Followers'])
  self.names[8] = 'Balanced'
end

#
#
#
module TwitterFriends
  module StructModel
    class BaseUserTweetMetrics < TypedStruct.new(
        [:id,                 Integer],
        [:tw_sampled,         Integer],
        [:last_tw_at,         Bignum],
        [:tw_recent,          Integer]
        )
    end
    class UserTweetMetrics    < BaseUserTweetMetrics ; end
    class UserTweetUrlMetrics < BaseUserTweetMetrics ; end
    class UserHashtagMetrics  < BaseUserTweetMetrics ; end

    # 1 rsrc 2 id 3 screen_name 4protect 5 age 6duratio 7age_use 8age_las 9 fo
    # 10fr 11 tw 12 fv 13 fr_fo 14 fo_week 15 fr_week 16 tw_day 17 fv_mo 18fo_sampled
    # 19fr_sampled 20tw_sampled 21tw_rece 22tw_day_ 23at_in_s 24at_out_ 25rt_in_s
    # 26rt_out_ 27fv_in_s 28fv_out_ 29any_wit 30any_out 31any_in_ 32at_in_w
    # 33at_out_ 34rt_in_w 35rt_out_ 36fv_in_w 37fv_out_ 38at_tw_o 39rt_tw_o
    # 40rt_at_o 41at_in_t 42rt_in_t 43rt_at_i 44 reach 45fo_cove 46fr_cove
    # 47tw_cove 48fv_cove 49scrape_ 50scrape_ 51scrape_ 52 scraped_at
    # 53part_scraped_at 54 created_at 55 last_tw_at

    module StructToSQL
      def to_sql_str
        members.zip(mtypes, mnames).each do |attr, type, name|
          type_str = case
                     when type <= String then  'VARCHAR(255) CHARACTER SET ASCII'
                     when type <= Enum   then  type.to_sql_str
                     else type.to_s.upcase
                     end
          puts "  %-23s\t%-23s\t-- %s" %["`#{attr}`", type_str+',', name]
        end
        [ UserMetrics.members.map{|attr| "`#{attr}`" }.join(", ") ]
      end
    end

    class NamedTypedStruct < TypedStruct
      def self.new *args
        members, mtypes, mnames = args.transpose
        thing = super *[members, mtypes].transpose
        if mnames
          thing.class_eval do
            cattr_accessor :mnames
            self.mnames = mnames
            extend StructToSQL
          end
        end
        thing
      end

    end


    class UserMetrics < NamedTypedStruct.new(
        [:id,                Integer   , "User ID"                                                 ],
        [:screen_name,       String    , "Twitter Name"                                            ],
        # 4
        [:created_on,        Date      , "Created On Date"                                         ],
        [:created_at,        DateTime  , "Created At Date-Time"                                    ],
        [:protected,         Integer   , "Protected?"                                              ],
        [:active,            TinyInt  , "Active?"                                                 ],
        # 8
        [:fo,                Integer   , "# Followers"                                             ],
        [:fr,                Integer   , "# Friends"                                               ],
        [:tw,                Integer   , "# Tweets Sent"                                           ],
        [:fv,                Integer   , "# Favorites Out"                                         ],
        # 12
        [:fo_week,           Float     , "Followers accumulated / week",                            ], #   x
        [:fr_week,           Float     , "Friends   accumulated / week",                            ], #   x
        [:tw_day,           Float     , "Tweets    sent / day",                                   ], #   x
        [:fv_mo,             Float     , "Favorites accumulated / month",                            ], #   x
        # 16
        [:tw_recent,         Integer   , "Tweets sampled 2008 Dec 1",                              ], #         t
        [:tw_day_recent,    Float     , "Recent Tweets / day (*)",                                ], #         t
        [:last_tw_at,        Date      , "Last Tweet Date (*)",                                    ], #         t
        [:last_tw_age,       Integer   , "Age of most recent tweet (*)",                           ],  #   x
        # 20
        [:at_in_sampled,     Integer   , "# @atsigns to (*)",                                      ], #       g
        [:at_out_sampled,    Integer   , "# @atsigns from (*)"                                     ], #       g
        [:rt_in_sampled,     Integer   , "# ReTweets of (*)",                                      ], #       g
        [:rt_out_sampled,    Integer   , "# ReTweets by (*)"                                       ], #       g
        [:fv_in_sampled,     Integer   , "# favorites of (*)",                                     ], #       g
        [:fv_out_sampled,    Integer   , "# favorites by (*)",                                     ], #     c
        # 26
        [:any_with,          Integer   , "Users linked to or from",                                ], #          A
        [:any_in_with,       Integer   , "Distinct At+RT+Fv users in",                             ], #          A
        [:any_out_with,      Integer   , "Distinct At+RT+Fv users out",                            ], #          A
        # 29
        [:at_in_with,        Integer   , "Users @atsigned in (*)",                                 ], #       g
        [:at_out_with,       Integer   , "Users @atsigned out (*)"                                 ], #       g",
        [:rt_in_with,        Integer   , "Users Retweeted in (*)",                                 ], #       g
        [:rt_out_with,       Integer   , "Users Retweeted out (*)"                                 ], #       g
        [:fv_in_with,        Integer   , "Users Favorited in (*)",                                 ], #       g
        [:fv_out_with,       Integer   , "Users Favorited out (*)",                                ], #     c
        # 35
        [:tw_sampled,        Integer , "How many tweets have we sampled",                        ], #         t
        [:hashtag_sampled,   Integer,  "How many hashtags have we seen"],
        [:tweet_url_sampled, Integer,  "How many tweet_url's have we seen"],
        [:at_tw_out,         Float     , "Atsigns  out per tweet out (*)",                         ], #       g
        [:rt_tw_out,         Float     , "Retweets out per tweet out (*)",                         ], #       g
        [:rt_at_out,         Float     , "Retweets out per atsign out (*)",                        ], #       g
        [:at_in_tw_out,      Float     , "Atsigns  in  per tweet out (*)",                         ], #       g
        [:rt_in_tw_out,      Float     , "Retweets in  per tweet out (*)",                         ], #       g
        [:rt_at_in,          Float     , "Retweets in  per atsign in (*)",                         ], #       g
        # 40
        [:nbhd_bal,          Float     , "Neighborhood Balance",                                   ], #
        [:nbhd_size,         Integer   , "Neighborhood Size",                                   ], #
        [:reach,             Integer   , "Reach: (tweets/day) * |followers|",                     ],  #   x
        # 43
        [:fo_bin,             FoBin      , "# Followers grp"],
        [:fr_bin,             FrBin      , "# Friends grp"],
        [:nbhd_size_bin,      NbhdSizeBin    , "Neighborhood Size grp"],
        [:nbhd_bal_bin,       NbhdBalBin     , "Neighborhood Balance grp"],
        [:tw_day_bin,        TwDayBin      , "Tweets / day grp (*)"],
        [:tw_day_recent_bin, TwDayRecentBin      , "Recent Tweets / day grp (*)"],
        #
        [:part_scraped_at,   Date      , "User partial Scrape Date",                       ], #
        [:scraped_at,        Date      , "User Scrape Date"                                                        ]
        # #
        # [:fo_sampled,      Integer   , "How many followers have we sampled",                     ], #     c
        # [:fr_sampled,      Integer   , "How many friend have we sampled",                        ], #     c
        # [:fo_coverage,       Float   , "Friends sampled   / known to exist",                     ], #     c
        # [:fr_coverage,       Float   , "Followers sampled / known to exist",                     ], #     c
        # [:tw_coverage,       Float   , "Tweets sampled    / known to exist",                     ], #     c
        # [:fv_coverage,       Float   , "Favorites sampled / known to exist",                     ], #     c
        # #
        # [:scrape_age_fo,     Integer , "How long since your followers graph record was scraped", ], #     c
        # [:scrape_age_fr,     Integer , "How long since your friends   graph record was scraped", ], #     c
        # [:scrape_age_fv,     Integer , "How long since your favorites graph record was scraped", ], #     c
        #
        # [:age,               Integer , "Days between creation and now",                          ], #   x
        # [:duration,          Integer , "Days between last scrape and creation",                  ], #   x
        # [:age_user_scrape,   Integer , "How long since your user record was scraped",            ], #   x
        )
      SCRAPING_DAY_ZERO_STR = 20081201000000
      SCRAPING_DAY_ZERO     = DateTime.parse(SCRAPING_DAY_ZERO_STR.to_s)
      SINCE_DAY_ZERO        = DateTime.now - SCRAPING_DAY_ZERO

      def fix!
        get_tw_day_bin
        get_tw_day_recent_bin
        get_fo_bin
        get_fr_bin
        get_nbhd_size_bin
        get_nbhd_bal_bin
        get_active
      end

      #
      # Fix formatting as we flatten
      #
      def to_a
        members.zip(mtypes).map do |member, type|
          val = self[member]
          next if val.nil?
          case
          when member.to_sym == :id     then "%010d"  % val.to_i
          when type == Float            then "%f"  % val.to_f
          when type == Integer          then "%7d"    % val.to_i
          when type == DateTime         then val.strftime("%Y/%m/%d %H:%M:%S")
          when type == Date             then val.strftime("%Y/%m/%d")
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
      def adopt_user user
        @user_adopted = true
        self.merge! user
        self.created_at = DateTime.parse_safely(created_at)
        self.scraped_at = DateTime.parse_safely(scraped_at)
      end
      def user_adopted?
        @user_adopted
      end

      #
      #
      #
      def adopt_user_partial user_partial
        user_scraped_at    = self.scraped_at
        self.merge! user_partial
        # restore scraped dates
        self.part_scraped_at = DateTime.parse_safely(user_partial.scraped_at)
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
      def adopt_tweet_metrics metrics
        case metrics
        when UserTweetMetrics
          self.tw_sampled   = metrics.tw_sampled
          self.last_tw_at   = DateTime.parse_safely(metrics.last_tw_at)
          self.tw_recent    = metrics.tw_recent
        when UserHashtagMetrics
          self.hashtag_sampled     = metrics.tw_sampled
        when UserTweetUrlMetrics
          self.tweet_url_sampled   = metrics.tw_sampled
        else raise "Can't adopt #{metrics}" end
      end

      def followers_count=( fo) self.fo = fo.to_i end
      def friends_count=(   fr) self.fr = fr.to_i end
      def statuses_count=(  tw) self.tw = tw.to_i end
      def favourites_count=(fv) self.fv = fv.to_i end
      def followers_count()     self.fo end
      def friends_count()       self.fr end
      def statuses_count()      self.tw end
      def favourites_count()    self.fv end
      #
      # Larger of fr and fo
      #
      def get_nbhd_size
        self.nbhd_size = [fr, fo].compact.max
      end
      #
      def get_nbhd_bal
        return unless fr && fo && ((fr.to_i > 0) || (fo.to_i > 0))
        self.nbhd_bal = ((fr > fo) ?
          (      (0.5 * fo.to_f / fr.to_f)) :
          (1.0 - (0.5 * fr.to_f / fo.to_f)) )
      end
      def get_created_on
        self.created_on = self.created_at
      end

      def crat
        @crat      ||= created_at
      end
      def scat
        @scat      ||= scraped_at
      end
      def part_scat
        @part_scat ||= part_scraped_at
      end
      def twat
        @twat      ||= last_tw_at
      end
      def now
        @now       ||= DateTime.now
      end


      #
      # duration --
      #
      def age()
        return @age if @age
        return unless crat
        @age             = ( now - crat ).to_i
      end
      def duration()
        return @duration if @duration
        return unless crat && (scat || part_scat)
        scat_latest = [scat, part_scat].compact.max
        @duration        = ( scat_latest - crat ).to_i
      end
      def get_last_tw_age()
        return unless twat && crat
        self.last_tw_age     = ( crat - twat ).to_i
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
      def get_fo_week()    self.fo_week = 7 * (fo.to_f / duration)     unless (duration.to_i == 0) || (!fo) end
      def get_fr_week()    self.fr_week = 7 * (fr.to_f / age)          unless (age.to_i == 0)      || (!fr) end
      def get_tw_day()     self.tw_day  =     (tw.to_f / duration)     unless (duration.to_i == 0) || (!tw) end
      def get_fv_mo()      self.fv_mo   = 30.4368499 * (fv.to_f / age) unless (age.to_i == 0)      || (!fv) end
      # def get_fr_fo()      self.fr_fo  = (fr.to_f / fo)   unless (fo.to_i       == 0) end
      def get_tw_day_recent()
        self.tw_day_recent = TWEETS_SAMPLED_FRACTION * (tw.to_f / SINCE_DAY_ZERO) unless (! tw)
      end

      #
      # Coverage: how many sampled vs. how many known to exist.
      #
      def get_fo_coverage()  self.fo_coverage = (fo_sampled.to_f     / fo) unless (fo.to_i == 0)  end
      def get_fr_coverage()  self.fr_coverage = (fr_sampled.to_f     / fr) unless (fr.to_i == 0)  end
      def get_tw_coverage()  self.tw_coverage = (tw_sampled.to_f     / tw) unless (tw.to_i == 0)  end
      def get_fv_coverage()  self.fv_coverage = (fv_out_sampled.to_f / fv) unless (fv.to_i == 0)  end

      #
      # Conversational metrics:
      #   favorites, @atsigns and RT's per tweet, in and out
      #    RT per @atsign, in and out
      #
      def get_at_tw_out()    self.at_tw_out    = (at_out_sampled.to_f / tw_sampled.to_f)     unless (tw_sampled.to_i == 0) || (! at_out_sampled)  end
      def get_rt_tw_out()    self.rt_tw_out    = (rt_out_sampled.to_f / tw_sampled.to_f)     unless (tw_sampled.to_i == 0) || (! rt_out_sampled)    end
      #
      def get_at_in_tw_out() self.at_in_tw_out = (at_in_sampled.to_f  / tw_sampled.to_f)     unless (tw_sampled.to_i == 0) || (! at_in_sampled)    end
      def get_rt_in_tw_out() self.rt_in_tw_out = (rt_in_sampled.to_f  / tw_sampled.to_f)     unless (tw_sampled.to_i == 0) || (! rt_in_sampled)    end
      #
      def get_rt_at_out()    self.rt_at_out    = (rt_out_sampled.to_f / at_out_sampled.to_f) unless (at_out_sampled.to_i == 0) || (! rt_out_sampled)   end
      def get_rt_at_in()     self.rt_at_in     = (rt_in_sampled.to_f  / at_in_sampled.to_f)  unless (at_in_sampled.to_i == 0)  || (! rt_in_sampled)    end

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


      #
      # Bins
      #
      def get_fo_bin()        self.fo_bin        = FoBin[fo]   end
      def get_fr_bin()        self.fr_bin        = FrBin[fr]   end
      def get_nbhd_size_bin() self.nbhd_size_bin = NbhdSizeBin[nbhd_size]  end
      def get_nbhd_bal_bin()  self.nbhd_bal_bin  = NbhdBalBin[nbhd_bal]    end
      def get_tw_day_bin()    self.tw_day_bin    = TwDayBin[tw_day]      end
      def get_tw_day_recent_bin()  self.tw_day_recent_bin  = TwDayRecentBin[tw_day_recent]   end
      def get_active()
        exists        = (fo && fr && tw) or return
        tweets        = tw >= 3
        has_followers = fo > 15
        has_nbhd      = (fo >= 3) && (fr >= 2)
        self.active = ( exists && tweets && (has_followers || has_nbhd) ) ? 1 : 0
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
