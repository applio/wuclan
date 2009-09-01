#!/usr/bin/env ruby
$: << ENV['WUKONG_PATH']
require File.dirname(__FILE__)+'/config/config_private'
require 'rubygems'
require 'trollop'
require 'wukong'
require 'monkeyshines'
require 'wuclan/twitter/scrape' ; include Wuclan

require 'monkeyshines/fetcher/http_fetcher'
require 'monkeyshines/utils/filename_pattern'

#
# Command line options
#
opts = Trollop::options do
  opt :dumpfile_dir,        "Filename base to store output. e.g. --dump_basename=/data/ripd", :type => String
  opt :dumpfile_pattern,    "Pattern for dump file output",
    :default => Monkeyshines::Utils::FilenamePattern::DEFAULT_PATTERN_STR
  opt :dumpfile_chunk_time, "Frequency to rotate chunk files (in seconds)", :type => Integer,
    :default => 60*60*24
  opt :handle,              "Handle to uniquely identify this scrape",
    :default => 'com.twitter.search'
  opt :min_resched_delay,   "Don't run jobs more often than this (in seconds)",
    :default => 60*1
end
Trollop::die :dumpfile_dir unless opts[:dumpfile_dir]

# Queue of request jobs, with reschedule requests
# opts[:beanstalk_tube] ||= opts[:handle].gsub(/\w+/,'_')
request_queue     = Monkeyshines::RequestStream::BeanstalkQueue.new(nil, Twitter::Scrape::TwitterSearchJob, opts[:items_per_job], opts.slice(:min_resched_delay)) # , :beanstalk_tube
# Scrape Store for completed requests
dumpfile_pattern  = Monkeyshines::Utils::FilenamePattern.new(opts[:dumpfile_pattern], opts.slice(:handle, :dumpfile_dir))
store             = Monkeyshines::Store::ChunkedFlatFileStore.new dumpfile_pattern, opts[:dumpfile_chunk_time].to_i
# Scrape requests by HTTP
fetcher           = Monkeyshines::Fetcher::HttpFetcher.new Monkeyshines::CONFIG[:twitter]
# Log every 60 seconds
periodic_log      = Monkeyshines::Monitor::PeriodicLogger.new(:time => 60)


class TwitterTrendingJob < Struct.new(
    :query_term,
    :priority,
    :period
    )

end


# %w[
#   http://search.twitter.com/trends/current.format  ,    60*60
#   http://search.twitter.com/trends/daily.json?date=2009-03-19
#   http://search.twitter.com/trends/weekly.json?date=2009-03-19
# ]



request_queue.each do |scrape_job|
  # Run through all pages for this search term
  scrape_job.each_request do |req|
    # Make request
    response = fetcher.get(req)
    # save it if successful
    store.save response if response
    # log progress
    periodic_log.periodically{ ["%7d"%response.num_items, response.url] }
    # return it to the scrape_job for bookkeeping
    response
  end
end
request_queue.finish

# Twitter::Scrape::Scrape_Job.hard_request_limit = 15
