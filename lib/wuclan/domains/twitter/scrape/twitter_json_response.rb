require 'wukong/encoding'
module Wuclan::Domains::Twitter::Scrape
  class JsonUserTweetPair
    attr_accessor :raw, :moreinfo
    def initialize raw, moreinfo
      self.raw = raw
      self.moreinfo = moreinfo
      fix_raw_user!
      fix_raw_tweet!
      # p ['new', self.class, raw, moreinfo]
    end

    # def separate_user_and_tweet raw
    #   raw_user  = raw
    #   raw_tweet =
    #   [raw_user, raw_tweet]
    # end


    #
    # Make the data easier for batch flat-record processing
    #
    def fix_raw_user!
      return unless raw_user
      raw_user['scraped_at'] = self.moreinfo['scraped_at']
      raw_user['created_at'] = ModelCommon.flatten_date(raw_user['created_at'])
      raw_user['id']         = ModelCommon.zeropad_id(  raw_user['id'])
      raw_user['protected']  = ModelCommon.unbooleanize(raw_user['protected'])
      raw_user['profile_background_tile']  = ModelCommon.unbooleanize(raw['profile_background_tile']) unless raw_user['profile_background_tile'].nil?
      Wukong.encode_components raw_user, 'name', 'location', 'description', 'url'
      # There are several users with bogus screen names
      # These we need to **URL encode** -- not XML-encode.
      if raw_user['screen_name'] !~ /\A\w+\z/
        raw_user['screen_name'] = Wukong.encode_str(raw_user['screen_name'], :url)
      end
    end

    #
    #
    # Make the data easier for batch flat-record processing
    #
    def fix_raw_tweet!
      return unless raw_tweet
      raw_tweet['id']                     = ModelCommon.zeropad_id(  raw_tweet['id'])
      raw_tweet['created_at']             = ModelCommon.flatten_date(raw_tweet['created_at'])
      raw_tweet['favorited']              = ModelCommon.unbooleanize(raw_tweet['favorited'])
      raw_tweet['truncated']              = ModelCommon.unbooleanize(raw_tweet['truncated'])
      raw_tweet['twitter_user_id']        = ModelCommon.zeropad_id(  raw_tweet['twitter_user_id'] )
      raw_tweet['in_reply_to_user_id']    = ModelCommon.zeropad_id(  raw_tweet['in_reply_to_user_id'])   unless raw_tweet['in_reply_to_user_id'].blank?   || (raw_tweet['in_reply_to_user_id'].to_i   == 0)
      raw_tweet['in_reply_to_status_id']  = ModelCommon.zeropad_id(  raw_tweet['in_reply_to_status_id']) unless raw_tweet['in_reply_to_status_id'].blank? || (raw_tweet['in_reply_to_status_id'].to_i == 0)
      Wukong.encode_components raw_tweet, 'text', 'in_reply_to_screen_name'
    end

    #
    # Before mid-2009, most calls returned only the fields in
    # TwitterUserPartial. After a mid-2009 API update, most calls return a full
    # user record: TwitterUser, TwitterUserStyle and TwitterUserProfile
    #
    # This method tries to guess, based on the fields in the raw_user, which it has.
    #
    def is_partial?
      not raw_user.include?('friends_count')
    end
    def tweet
      Tweet.from_hash raw_tweet if raw_tweet
    end

    def user
      if is_partial?
        TwitterUserPartial.from_hash raw_user
      else
        TwitterUser.from_hash raw_user
      end
    end
    def user_profile
      TwitterUserProfile.from_hash raw_user
    end
    def user_style
      TwitterUserStyle.from_hash raw_user
    end

    # Extracted JSON should be an array
    def healthy?()
      raw && raw.is_a?(Hash) && (raw_tweet.nil? || raw_tweet.is_a?(Hash))
    end

    def each
      if is_partial?
        yield user
      else
        yield user
        yield user_profile
        yield user_style
      end
      yield tweet if tweet
    end

  end
end


class JsonUserWithTweet < JsonUserTweetPair

  def raw_tweet
    return @raw_tweet if @raw_tweet
    @raw_tweet = raw['status']
    @raw_tweet['twitter_user_id'] = raw_user['id'] if @raw_tweet
    @raw_tweet
  end
  def raw_user
    @raw_user ||= raw
  end
end


class JsonTweetWithUser < JsonUserTweetPair

  def raw_tweet
    @raw_tweet ||= raw
  end
  def raw_user
    return @raw_user if @raw_user
    @raw_user = raw['user']
    @raw_user
  end
end
