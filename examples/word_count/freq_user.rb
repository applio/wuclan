#!/usr/bin/env ruby
$: << File.dirname(__FILE__)+'/../../lib'
require 'rubygems'
require 'wukong'
require 'wuclan'                       ; include Wuclan::Models
require 'wuclan/models/tweet/tokenize'
require 'wukong/streamer/count_keys'
require 'wukong/streamer/count_lines'

module FreqUser
  class Mapper < Wukong::Streamer::StructStreamer
    #
    # extract just the word
    #
    def process thing, &block
      next unless thing.is_a? TweetToken
      yield [thing.user_id, thing.word]
    end
  end

  class Reducer < Wukong::Streamer::CountLines
  end

  # Execute the script
  Wukong::Script.new(
    Mapper,
    Reducer,
    :partition_fields => 2,
    :sort_fields      => 2
    ).run
end
