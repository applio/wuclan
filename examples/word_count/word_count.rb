#!/usr/bin/env ruby
$: << File.dirname(__FILE__)+'/../../lib'

require 'rubygems'
# require 'active_support'
require 'wukong'                       ; include Wukong
require 'twitter_friends/struct_model' ; include TwitterFriends::StructModel
require 'twitter_friends/grok'         ; include TwitterFriends::Grok::TweetRegexes
require 'twitter_friends/words'
require 'wukong/streamer/count_keys'

#
# See bundle.sh for running pattern
#

class SearchResult < Struct.new(:screen_name, :id, :junk, :created_at, :text, :junk2, :twitter_user_id, :lang)
  #
  # Memoized; if you change text you have to flush
  #
  def decoded_text
    @decoded_text ||= text.wukong_decode
  end
end

module WordFreq
  class Mapper < Wukong::Streamer::StructStreamer

    #
    # This is pretty simpleminded.
    #
    # Would be much better to use NLTK. But here we are.
    #
    def tokenize t
      return [] unless t
      t = t.downcase;
      # kill off all punctuation except 's
      # this includes hyphens (words are split)
      t = t.gsub(/[^\w\'@]+/, ' ').gsub(/\'([st])\b/, '!\1').gsub(/\'/, ' ').gsub(/!/, "'")
      # Busticate at whitespace
      words = t.strip.split(/\s+/)
      words.reject!{|w| w.blank? || (w.length < 3) }
      words
    end

    def extract_tokens! t, extract_re
      toks = []
      t.gsub!(extract_re){|tok| toks << $1.strip ; ' '}
      toks
    end

    #
    # remove elements specific to tweets
    #
    def tokenize_tweet_text t, &block
      # skip default message from early days
      return [] if (! t) || (t =~ /just setting up my twttr/);
      t = t.gsub(/[\r\n\t]+/,' ').strip
      # Extract semantic elements.
      extract_tokens!(t, RE_SMILIES ).each{|tok| yield [tok,          :smilie]}
      extract_tokens!(t, RE_URL     ).each{|tok| yield [tok,          :url   ]}
      t = t.downcase;
      extract_tokens!(t, RE_RETWEET ).each{|tok| yield ["RT_@#{tok}", :retweet] }
      extract_tokens!(t, RE_ATSIGNS ).each{|tok| yield ['@'+tok,      :atsign]  }
      extract_tokens!(t, RE_HASHTAGS).each{|tok| yield ['#'+tok,      :hashtag] }
      # Tokenize the remainder
      tokenize(t).each{|tok|                     yield [tok,          :word] }
    end

    def gen_tweet_tokens tweet
      # simpleminded test for non-latin script: don't bother if > 20 entities
      return [] if tweet.text.count('&') > 20
      # Tokenize
      tokenize_tweet_text(tweet.decoded_text) do |word, kind|
        yield Token.new(:tweet, kind, tweet.twitter_user_id, tweet.id, word).to_flat(false)
      end
    end

    def gen_profile_tokens user_profile
      desc = user_profile.decoded_description
      tokenize(desc).each do |word|
        yield Token.new(:desc, user_profile.id, word)
      end
      name = user_profile.decoded_name
      tokenize(name).each do |word|
        yield Token.new(:name, user_profile.id, word)
      end
      loc = user_profile.decoded_location
      tokenize(loc).each do |word|
        yield Token.new(:loc,  user_profile.id, word)
      end
    end

    #
    # Generate all words (tokens) used in tweets
    # and all tokens used in users' locations, descriptions or names
    # each tagged according to their origin.
    #
    def process thing, &block
      case thing
      when Tweet                then gen_tweet_tokens(thing, &block)
      when SearchResult         then gen_tweet_tokens(thing, &block)
      # when TwitterUserProfile   then gen_profile_tokens(thing)
      end
    end
  end

  # class Reducer < Wukong::Streamer::CountKeys
  # end

  #
  #
  class Script < Wukong::Script
    def default_options
      super.merge :reduce_tasks => 0
    end
  end
end

#
# Executes the script
#
WordFreq::Script.new(
  WordFreq::Mapper,
  nil # WordFreq::Reducer
  ).run
