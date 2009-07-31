#!/usr/bin/env ruby
$: << File.dirname(__FILE__)+'/../../lib'

require 'rubygems'
# require 'active_support'
require 'wukong'                       ; include Wukong
require 'wuclan'                       ; include Wuclan::Models
require 'wuclan/models/tweet/tokenize'

module WordFreq
  class Mapper < Wukong::Streamer::StructStreamer
    #
    # Extract all the semantic items (smilies, hashtags, etc)
    # and all the remaining words from each tweet
    #
    def process thing, *args, &block
      next unless thing.is_a? Tweet
      # tokenize(true) to extract words as well as semantic tokens
      thing.tokenize(true).each do |token|
        # we call to_flat(false) to get the simple key
        yield token.to_flat(false)
      end
    end
  end


  # Execute the script
  Wukong::Script.new(
    Mapper,
    nil, # Reducer
    :reduce_tasks => 0
    ).run
end

