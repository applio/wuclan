#!/usr/bin/env ruby
require 'rubygems'
require 'wukong'
require 'monkeyshines'
require 'wuclan/twitter'
# un-namespace request classes.
include Wuclan::Twitter::Scrape
include Wuclan::Twitter::Model
# if you're anyone but original author this next require is useless but harmless.
require 'wuclan/twitter/scrape/old_skool_request_classes'

#
# req, id, page, scraped_at, response_code
#
REQUEST_MAPPER_COMMAND = "/usr/bin/cut -d\"\t\" -f1,3,4,7,8 "

class TwitterRequestUniqer < Wukong::Streamer::UniqByLastReducer
  attr_accessor :response_codes
  def get_key req=nil, id=nil, pg=nil, *args
    [req, id]
  end

  def start! *args
    self.response_codes = { 200=>0,400=>0,401=>0,403=>0,404=>0 }
    super *args
  end

  require 'json'
  def accumulate *args
    req, id, page, scraped_at, resp = args
    resp = resp.to_i
    return unless scraped_at =~ /\d{14}/
    response_codes[resp] += 1 if response_codes.include?(resp)
    super *args
  end

  def finalize *args
    return if final_value.blank?
    req, id, page, scraped_at, resp = final_value
    id = "%010d"%(id.to_i)
    yield( [id, req, page, scraped_at] + response_codes.values_at(200,400,401,403,404) )
  end
end


# Make the script go.
Wukong::Script.new(
  nil, TwitterRequestUniqer,
  :map_command      => REQUEST_MAPPER_COMMAND,
  :partition_fields => 2, :sort_fields => 3
  ).run


#    49522
# 74975395  200
#       84  302
#   277786  400
#   972881  401
#    94647  403
#   178105  404
#     9710  500
#    23134  502
#     1588  503
#     2479  504

# Wuclan::Twitter::Scrape::Base.class_eval do class_inheritable_accessor :req_code ; end
# TwitterUserRequest.class_eval         do self.req_code = :tw_user ; end
# TwitterFollowersRequest.class_eval    do self.req_code = :tw_foll ; end
# TwitterFriendsRequest.class_eval      do self.req_code = :tw_frnd ; end
# TwitterFollowersIdsRequest.class_eval do self.req_code = :tw_foid ; end
# TwitterFriendsIdsRequest.class_eval   do self.req_code = :tw_frid ; end
# TwitterUserTimelineRequest.class_eval do self.req_code = :tw_ustl ; end
#
# REQ_CODES = {
#   'followers'     => :tw_fo, 'twitter_followers_request'     => :tw_fo,
#   'friends'       => :tw_fr, 'twitter_friends_request'       => :tw_fr,
#   'followers_ids' => :tw_fi, 'twitter_followers_ids_request' => :tw_fi,
#   'friends_ids'   => :tw_ri, 'twitter_friends_ids_request'   => :tw_ri,
#   'user'          => :tw_us, 'twitter_user_request'          => :tw_us,
#   'user_timeline' => :tw_ut, 'twitter_user_timeline_request' => :tw_ut,
# }

# #
# #
# #
# class TwitterRequestParser < Wukong::Streamer::StructStreamer
#
#   def process request, *args, &block
#     next if request.page.to_i > 1
#     next if request.response_code != '200'
#     req_code = REQ_CODES[request]
#     case request
#     when TwitterUserRequest, TwitterFollowersRequest, TwitterFriendsRequest,
#       TwitterFollowersIdsRequest, TwitterFriendsIdsRequest, TwitterUserTimelineRequest
#       yield [request.twitter_user_id, request.req_code, request.scraped_at]
#     end
#   end
# end
