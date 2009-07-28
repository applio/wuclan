#!/usr/bin/env ruby
$: << File.dirname(__FILE__)+'/../../lib'
require 'wukong'
require 'wuclan/models'; include Wuclan::Models
require 'wuclan/models/multi_edge'

TwitterUser.class_eval do
  def age
  end
end

# Common to all user-user relationships.
module RelationshipBase
  def both_edge_rels
    [ ["a_#{self.class.rel_name}_b", user_a_id, user_b_id],
      ["b_#{self.class.rel_name}_a", user_b_id, user_a_id] ]
  end
end


class Mapper < Wukong::Streamer::StructStreamer
  def process thing, *args
    case thing
    when AFollowsB, AAtsignsBId
      thing.both_edge_rels.each{|edge| yield edge }
    end
  end
end

class Reducer < Wukong::Streamer::AccumulatingReducer
end

#
# Sort on the first two keys: each @[src, dest]@ pair winds up at the same
# reducer.
#
class Script < Wukong::Script
  def default_options
    super.merge :sort_fields => 2
  end
end

# Execute the script
Script.new(Mapper, Reducer).run


#
# Take
#   a < [... followers ...]
# and
#
