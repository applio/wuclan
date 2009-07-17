#!/usr/bin/env ruby
$: << ENV['WUKONG_PATH']
require File.dirname(__FILE__)+'/config/config_private'
require 'rubygems'
require 'trollop'
require 'wukong'
require 'monkeyshines'
require 'wuclan/domains/twitter/scrape' ; include Wuclan::Domains
require 'monkeyshines/scrape_engine/http_scraper'
require 'monkeyshines/utils/filename_pattern'

#
# Command line options
#
opts = Trollop::options do
  opt :dumpfile_filename,   "Filename base to store output. e.g. --dump_basename=/data/ripd", :type => String
  opt :dumpfile_pattern,    "Pattern for dump file output",            :default => ":dumpfile_dir/:handle_prefix/:handle/:date/:handle+:datetime-:pid.tsv"
  opt :dumpfile_chunk_time, "Time in seconds to keep dump files open", :default => 60*60*4, :type => Integer
  opt :handle,              "Handle to uniquely identify this scrape", :default => 'com.twitter.search'
end
Trollop::die :dumpfile_dir unless opts[:dumpfile_dir]

# Queue of request sessions, with reschedule requests
request_queue     = Monkeyshines::RequestStream::BeanstalkQueue.new(nil, Twitter::Scrape::Session, RESCHEDULE_GOAL)
# Scrape Store for completed requests
dumpfile_pattern  = Monkeyshines::Utils::FilenamePattern.new(opts[:dumpfile_pattern], opts.slice(:handle, :dumpfile_dir))
store             = Monkeyshines::ScrapeStore::ChunkedFlatFileStore.new dumpfile_pattern, opts[:dumpfile_chunk_time].to_i
# Scrape requests by HTTP
scraper           = Monkeyshines::ScrapeEngine::HttpScraper.new Monkeyshines::CONFIG[:twitter]
# Log every N requests
periodic_log      = Monkeyshines::Monitor::PeriodicLogger.new(:time_interval => 60)


RESCHEDULE_GOAL = 650
Twitter::Scrape::Session.hard_request_limit = 15
request_queue.min_resched_delay = 180


request_queue.each do |session|
  # Run through all pages for this search term
  session.each_request do |req|
    # Make request
    response = scraper.get(req)
    # save it if successful
    store.save response if response
    # log progress
    periodic_log.periodically{ ["%7d"%response.num_items, response.url] }
    # return it to the session for bookkeeping
    response
  end
end
request_queue.finish
#
# # # (1..50).map{ begin j = bs.reserve(1) ; rescue Exception => e ; warn e ; break ; end ; if j then q = j.body.gsub(/\t.*/,"") ; queries[q] ||= j.id ; if (queries[q] != j.id) then j.delete end ; j.release 65536, 45 ; puts q ; q end rescue 'error' }
