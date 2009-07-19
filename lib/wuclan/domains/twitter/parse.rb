module Wuclan
  module Request
    #
    # Extract the content of the request
    # as wuclan structs
    #
    class Parse
    end
  end
end
require 'rubygems'; require 'json'
require 'wuclan/json_model/generic_json_parser'
require 'wuclan/json_model/json_tweet'
require 'wuclan/json_model/json_twitter_user'
require 'wuclan/json_model/public_timeline_parser'
require 'wuclan/json_model/friends_followers_parser'
require 'wuclan/json_model/user_parser'
require 'wuclan/json_model/ff_ids_parser'
