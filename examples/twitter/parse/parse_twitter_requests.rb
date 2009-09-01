#!/usr/bin/env jruby
#$: << ENV['WUKONG_PATH']
require 'rubygems'
require 'trollop'
require 'wukong'
require 'monkeyshines'
require 'wuclan/twitter'
# un-namespace request classes.
include Wuclan::Twitter::Scrape
include Wuclan::Twitter::Model
# if you're anyone but original author this next require is useless but harmless.
require 'wuclan/twitter/scrape/old_skool_request_classes'

#
#
# Instantiate each incoming request.
# Stream out the contained classes it generates.
#
#
class TwitterRequestParser < Wukong::Streamer::StructStreamer

  def process request, *args, &block
    request.parse(*args) do |obj|
      next if obj.is_a? BadRecord
      yield obj.to_flat(false)
    end
  end
end

#
# We want to record each individual state of the resource, with the last-seen of
# its timestamps (if there are many). So if we saw
#
#     rsrc  id   screen_name   followers_count  friends_count  (... more)
#     user  23   skidoo        47               61
#     user  23   skidoo        48               62
#     user  23   skidoo        48               62
#     user  23   skidoo        52               62
#     user  23   skidoo        52               63
#
#
class TwitterRequestUniqer < Wukong::Streamer::UniqByLastReducer
  include Wukong::Streamer::StructRecordizer

  attr_accessor :uniquer_count

  #
  #
  #
  #
  # for immutable objects we can just work off their ID.
  #
  # for mutable objects we want to record each unique state: all the fields
  # apart from the scraped_at timestamp.
  #
  def get_key obj
    case obj
    when Tweet
      obj.id
    when AFollowsB, AFavoritesB, ARepliesB, AAtsignsB, AAtsignsBId, ARetweetsB, ARetweetsBId, TwitterUserId
      obj.key
    when TwitterUser, TwitterUserProfile, TwitterUserStyle, TwitterUserPartial
      [obj.id] + obj.to_a[2..-1]
    else
      raise "Don't know how to extract key from #{obj.class}"
    end
  end

  def start! *args
    self.uniquer_count = 0
    super *args
  end

  def accumulate obj
    self.uniquer_count      += 1
    self.final_value = [self.uniquer_count, obj.to_flat].flatten
  end
end

# This makes the script go.
Wukong::Script.new(TwitterRequestParser, TwitterRequestUniqer).run
