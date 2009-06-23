require 'wuclan/models/tweet/tweet_token'
require 'wukong/encoding'
module Wuclan::Models
  Tweet.class_eval do
    def string_for_tokenizing
      # simpleminded test for non-latin script: don't bother if > 20 entities
      return if (text.count('&') > 20)
      # skip default message from early days
      return if (text =~ /just setting up my twttr/);
      # return decoded, whitespace-flattened text
      self.decoded_text.gsub(/\s+/s, ' ').strip
    end

    def tokens_for klass, str
      klass.extract_tokens!(str).map do |word|
        klass.new(word, twitter_user_id, id, 1)
      end
    end

    def tokenize extract_word_tokens=nil
      str = string_for_tokenizing
      return [] if str.blank?
      toks = []
      # Case-sensitive tokens
      [ SmilieToken, UrlToken ].each do |klass|
        toks += tokens_for klass, str
      end
      # Case-insensitive tokens
      str.downcase!
      [ RtToken, AtsignToken, HashtagToken ].each do |klass| # ,
        toks += tokens_for klass, str
      end
      toks += tokens_for WordToken, str if extract_word_tokens
      toks
    end

  end
end
