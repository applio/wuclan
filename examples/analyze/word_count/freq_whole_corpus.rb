#!/usr/bin/env ruby
$: << File.dirname(__FILE__)+'/../../lib'
require 'rubygems'
require 'wukong'
require 'wuclan'                       ; include Wuclan::Models
require 'wuclan/models/tweet/tokenize'
require 'wukong/streamer/count_keys'

module FreqWholeCorpus
  class Mapper < Wukong::Streamer::StructStreamer
    #
    # extract just the word
    #
    def process thing, *args, &block
      next unless thing.is_a? TweetToken
      yield thing.word
    end
  end

  # Execute the script
  Wukong::Script.new(
    Mapper,
    Wukong::Streamer::CountKeys
    ).run
end


