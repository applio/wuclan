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
  opt :handle,              "Handle to uniquely identify this scrape",          :default => 'com.twitter.search'
  opt :items_per_job,       "Desired item count per job",                       :default => 1000
  opt :min_resched_delay,   "Don't run jobs more often than this (in seconds)", :default => 20*1
  opt :job_db,              "Tokyo tyrant db host",                             :default => ':1978', :type => String
  opt :log,                 "Log file name; leave blank to use STDERR",         :type => String
  # output storage
  opt :chunk_time,     "Frequency to rotate chunk files (in seconds)", :type => Integer, :default => 60*60*4
  opt :dest_dir,       "Filename base to store output. e.g. --dump_basename=/data/ripd", :type => String
  opt :dest_pattern,   "Pattern for dump file output",                 :default => ":dest_dir/:handle_prefix/:handle/:date/:handle+:datetime-:pid.tsv"
end
Trollop::die :dest_dir unless opts[:dest_dir]
Monkeyshines.logger = Logger.new(opts[:log], 'daily') if opts[:log]

# Queue of request scrape_jobs, with reschedule requests
beanstalk_tube  = opts[:handle].gsub(/\w+/,'_')
request_queue   = Monkeyshines::RequestStream::BeanstalkQueue.new(nil, Twitter::Scrape::TwitterSearchJob, opts[:items_per_job], opts.slice(:min_resched_delay))
# Scrape Store for completed requests
dest_pattern    = Monkeyshines::Utils::FilenamePattern.new(opts[:dest_pattern], opts.slice(:handle, :dest_dir))
dest            = Monkeyshines::ScrapeStore::ChunkedFlatFileStore.new dest_pattern, opts[:chunk_time].to_i
# Scrape requests by HTTP
scraper         = Monkeyshines::ScrapeEngine::HttpScraper.new Monkeyshines::CONFIG[:twitter]
# Log every 60 seconds
periodic_log    = Monkeyshines::Monitor::PeriodicLogger.new(:time_interval => 60)
# Persist scrape_job jobs in distributed DB
job_store       = Monkeyshines::ScrapeStore::TyrantTdbKeyStore.new(opts[:job_db])

request_queue.each do |scrape_job|
  # Run through all pages for this search term
  scrape_job.each_request do |req|
    # Fetch request
    response = scraper.get(req)
    # save it if successful
    dest.save response if response
    # log progress
    periodic_log.periodically{ ["%7d"%response.num_items, response.url] }
    # return it to the scrape_job for bookkeeping
    response
  end
  # Persist the updated job to the scrape_jobs db, so that we can restart queue easily
  job_store.save "#{scrape_job.class}-#{scrape_job.query_term}", scrape_job.to_hash.compact
  # sleep 0.5
end
request_queue.finish
