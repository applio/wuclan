require 'wuclan/models/tweet/tweet_regexes'
module Wuclan::Models

  class TweetToken < TypedStruct.new(
      [:word,           String],
      [:user_id,        Integer],
      [:tweet_id,       Integer],
      [:freq,            Integer]
      )
    include ModelCommon
    include TweetRegexes
    class_inheritable_accessor :extract_re

    def initialize *args
      super *args
      freq = 1 if freq.blank? && (! word.blank?)
    end

    def num_key_fields()     5  end
    def numeric_id_fields()  [] ; end

    # crawl through the string
    # remove each token, leave a space behind
    def self.extract_tokens! str
      toks = []
      str.gsub!(extract_re){|tok| toks << $1.strip ; ' ' }
      toks
    end
  end

  class SmilieToken < TweetToken
    self.extract_re = RE_SMILIES
  end
  class UrlToken < TweetToken
    self.extract_re = RE_URL
  end
  class RtToken < TweetToken
    self.extract_re = RE_RETWEET
    def self.extract_tokens! str
      super.map{|str| str = 'RT_@'+str }
    end
  end
  class AtsignToken < TweetToken
    self.extract_re = RE_ATSIGNS
    def self.extract_tokens! str
      super.map{|str| str = '@'+str }
    end
  end
  class HashtagToken < TweetToken
    self.extract_re = RE_HASHTAGS
    def self.extract_tokens! str
      super.map{|str| str = '#'+str }
    end
  end
  class WordToken < TweetToken
    self.extract_re = nil
    #
    # This is pretty simpleminded.
    #
    # returns all words of three or more letters.
    # * terminal 't and 's (as in "don't" and "it's") are tokenised together
    # *
    #
    # * FIXME -- this doesn't leave str as blank, as it should to behave like
    #   the other ! methods
    def self.extract_tokens! str
      return [] unless str
      str = str.downcase;
      # kill off all punctuation except 's
      # this includes hyphens (words are split)
      str = str.gsub(/[^\w\'@]+/, ' ').gsub(/\'([st])\b/, '!\1').gsub(/\'/, ' ').gsub(/!/, "'")
      # Busticate at whitespace
      words = str.strip.split(/\s+/)
      #
      words.reject{|w| w.blank? || (w.length < 3) }
    end
  end

end
