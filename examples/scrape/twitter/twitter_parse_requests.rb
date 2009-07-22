#!/usr/bin/env ruby
$: << ENV['WUKONG_PATH']
# require File.dirname(__FILE__)+'/config/config_private'
require 'rubygems'
require 'trollop'
require 'wukong'
require 'monkeyshines'
require 'wuclan/domains/twitter'
include Wuclan::Domains::Twitter::Scrape
include Wuclan::Domains::Twitter::Model
require 'wuclan/domains/twitter/scrape/twitter_followers_request'
require 'wuclan/domains/twitter/scrape/twitter_json_response'

#
# Older versions had a slightly different layout
#
module OldSkoolRequest
  def initialize(priority, twitter_user_id, page, screen_name, *args) super(*args) ;
    self.twitter_user_id = twitter_user_id
  end
end
class Followers < TwitterFollowersRequest ; include OldSkoolRequest ; end
class Friends   < TwitterFriendsRequest   ; include OldSkoolRequest ; end
class Favorites < TwitterFavoritesRequest   ; include OldSkoolRequest ; end

module TwitterParseRequest
 class Mapper < Wukong::Streamer::StructStreamer

    # def recordize line
    #   rsrc, rest = line.split("\t",2)
    #   puts rsrc.inspect[0..100]
    #   # 'Wuclan::Domains::Twitter::Scrape::TwitterFollowersRequest'+"\t"+rest  #
    #   super 'twitter_'+rsrc+"_request\t"+ rest
    # end

    def process request
      # p request
      request.parse do |obj|
        puts obj.to_flat.join("\t")
      end
    end

  end

  Wukong::Script.new(Mapper, nil).run
end
