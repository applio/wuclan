#!/usr/bin/env ruby
$: << File.dirname(__FILE__)+'/../../lib'

require 'rubygems'
# require 'active_support'
require 'wukong'                       ; include Wukong
require 'wuclan'                       ; include Wuclan::Models
require 'wuclan/models/tweet/tokenize'

load '/home/flip/ics/projects/twitter_friends/lib/twitter_friends/and_pig/init_load.rb'


pig_load_dir 'meta/aorf/word_count', TweetToken
