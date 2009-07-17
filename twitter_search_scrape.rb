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
  opt :dumpfile_dir,        "Filename base to store output. e.g. --dump_basename=/data/ripd", :type => String
  opt :dumpfile_pattern,    "Pattern for dump file output",
    :default => ":dumpfile_dir/:handle_prefix/:handle/:date/:handle+:datetime-:pid.tsv"
  opt :dumpfile_chunk_time, "Frequency to rotate chunk files (in seconds)", :type => Integer,
    :default => 60*60*4
  opt :handle,              "Handle to uniquely identify this scrape",
    :default => 'com.twitter.search'
  opt :items_per_job,       "Desired item count per job",
    :default => 980
  opt :min_resched_delay,   "Don't run jobs more often than this (in seconds)",
    :default => 60*1
end
Trollop::die :dumpfile_dir unless opts[:dumpfile_dir]

# Queue of request scrape_jobs, with reschedule requests
beanstalk_tube    = opts[:handle].gsub(/\w+/,'_')
request_queue     = Monkeyshines::RequestStream::BeanstalkQueue.new(nil, Twitter::Scrape::TwitterSearchJob, opts[:items_per_job], opts.slice(:min_resched_delay))
# Scrape Store for completed requests
dumpfile_pattern  = Monkeyshines::Utils::FilenamePattern.new(opts[:dumpfile_pattern], opts.slice(:handle, :dumpfile_dir))
store             = Monkeyshines::ScrapeStore::ChunkedFlatFileStore.new dumpfile_pattern, opts[:dumpfile_chunk_time].to_i
# Scrape requests by HTTP
scraper           = Monkeyshines::ScrapeEngine::HttpScraper.new Monkeyshines::CONFIG[:twitter]
# Log every 60 seconds
periodic_log      = Monkeyshines::Monitor::PeriodicLogger.new(:time_interval => 60)

request_queue.each do |scrape_job|
  # Run through all pages for this search term
  scrape_job.each_request do |req|
    # Make request
    response = scraper.get(req)
    # save it if successful
    store.save response if response
    # log progress
    periodic_log.periodically{ ["%7d"%response.num_items, response.url] }
    # return it to the scrape_job for bookkeeping
    response
  end
  sleep 0.5
end
request_queue.finish

# Twitter::Scrape::TwitterSearchJob.hard_request_limit = 15
