#!/usr/bin/env ruby
require 'rubygems'
require 'monkeyshines'
require 'monkeyshines/utils/trollop'
require 'edamame'
# Setup
WORK_DIR = Subdir[__FILE__,'work'].expand_path.to_s
require 'wuclan/twitter' ; include Wuclan::Twitter::Scrape
Monkeyshines.load_global_options!
Monkeyshines::CONFIG[:fetcher] = Monkeyshines::CONFIG[:twitter_api]

include Edamame::Scheduling

options = Trollop::options do
  opt :handle,          "Identifying string for scrape",     :type => String, :required => true
  opt :source_filename, "URI for scrape store to load from", :type => String, :required => true
end
default_tube = options[:handle].to_s.gsub(/\W+/,'').gsub(/_/,'-')
p default_tube

DEFAULT_PRIORITY        = 65536
DEFAULT_TTR             = nil
DEFAULT_RESERVE_TIMEOUT = 15
IMMEDIATELY             = 0
source = Monkeyshines::Store::FlatFileStore.new :filename => options[:source_filename]
dest = Edamame::PersistentQueue.new( :tube => default_tube,
  :queue => { :uris => ['localhost:11240'], },
  :store => { :uri =>            ':11241',  }
  )
source.each do |query_term, priority, prev_rate, prev_items, prev_span_min, prev_span_max|
  query_term.strip!
  priority      = priority.to_i
  prev_items    = prev_items.to_i
  prev_span_min = prev_span_min.to_i
  prev_span_max = prev_span_max.to_i
  prev_rate     = prev_rate.to_f
  priority      = DEFAULT_PRIORITY if (priority  == 0  )
  prev_rate     = nil              if (prev_rate < 1e-6)

  twitter_search = { :type => 'TwitterSearchRequest', :key => query_term }

  job = Edamame::Job.new(default_tube, priority, nil, 1,
    Recurring.new(1000.0 / prev_rate.to_f, prev_span_max, prev_items, prev_rate),
    twitter_search
    )
  dest.put job, job.priority, IMMEDIATELY
end


# loop do
#   job    = dest.reserve(DEFAULT_RESERVE_TIMEOUT) or break
#   p [job, job.priority, job.scheduling, job.obj]
#   # dest.delete job
# end
