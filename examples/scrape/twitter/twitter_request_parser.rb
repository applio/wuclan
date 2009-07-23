#!/usr/bin/env ruby
$: << ENV['WUKONG_PATH']
require 'rubygems'
require 'trollop'
require 'wukong'
require 'monkeyshines'
require 'wuclan/domains/twitter'
# un-namespace request classes.
include Wuclan::Domains::Twitter::Scrape
# if you're anyone but original author this next require is useless but harmless.
require 'wuclan/domains/twitter/scrape/old_skool_request_classes'
# 
#
# Instantiate each incoming request.
# Stream out the contained classes it generates.
#
# 
class TwitterRequestParser < Wukong::Streamer::StructStreamer
  def process request
    request.parse do |obj|
      yield obj
    end
  end
end

# This makes the script go.
Wukong::Script.new(TwitterRequestParser, nil).run
