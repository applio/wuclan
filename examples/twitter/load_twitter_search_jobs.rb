#!/usr/bin/env ruby
$: << ENV['WUKONG_PATH']
require File.dirname(__FILE__)+'/config/config_private'
require 'rubygems'
require 'trollop'
require 'wukong'
require 'monkeyshines'
#
require 'wuclan/domains/twitter/scrape' ; include Wuclan
require 'monkeyshines/utils/uri'
require 'monkeyshines/fetcher/http_fetcher'
#
# Command line options
#
opts = Trollop::options do
  opt :handle,              "Handle to uniquely identify this scrape",          :default => 'com.twitter.search'
  opt :items_per_job,       "Desired item count per job",                       :default => 675
  opt :min_resched_delay,   "Don't run jobs more often than this (in seconds)", :default => 30*1
  opt :job_db,            "Tokyo tyrant db host",                             :default => ':1978', :type => String
  opt :log,                 "Log file name; leave blank to use STDERR",         :type => String
  # import from file
  opt :from,           "Location of scrape store to load from",            :type => String
  # output storage
  opt :chunk_time,     "Frequency to rotate chunk files (in seconds)", :type => Integer, :default => 60*60*4
  opt :dest_dir,       "Filename base to store output. e.g. --dump_basename=/data/ripd", :type => String
  opt :dest_pattern,   "Pattern for dump file output",                 :default => ":dest_dir/:handle_prefix/:handle/:date/:handle+:datetime-:pid.tsv"
end

module Wuclan
  module Domains
    module Twitter
      module Scrape
        TwitterSearchJob = Struct.new(
          :query_term,
          :priority,
          :prev_items,
          :prev_rate,
          :prev_span_min,
          :prev_span_max
          )
      end
    end
  end
end


# Queue of request import_jobs, with reschedule requests
beanstalk_tube  = opts[:handle].gsub(/\w+/,'_')
request_queue   = Monkeyshines::RequestStream::BeanstalkQueue.new(nil, Twitter::Scrape::TwitterSearchJob, opts[:items_per_job], opts.slice(:min_resched_delay))
# Scrape requests by HTTP
fetcher         = Monkeyshines::Fetcher::HttpFetcher.new Monkeyshines::CONFIG[:twitter]
# Log every 60 seconds
periodic_log    = Monkeyshines::Monitor::PeriodicLogger.new(:time => 60)
# Persist scrape_job jobs in distributed DB
job_store       = Monkeyshines::Store::TyrantTdbKeyStore.new(opts[:job_db])

# Import
if opts[:from]
  import_jobs = Monkeyshines::Store::FlatFileStore.new(opts[:from], :filemode => 'r')
end

#
# Keep one unique copy of each scrape_job.  The most senior instance (the one
# with the highest prev_items) wins.
#
SCRAPES = { }
def add_scrape_job scrape_job
  return if SCRAPES[scrape_job.query_term] &&
    (SCRAPES[scrape_job.query_term].prev_items.to_i >= scrape_job.prev_items.to_i)
  SCRAPES[scrape_job.query_term] = scrape_job
end

Monkeyshines::RequestStream::BeanstalkQueue.class_eval do
  #
  # An (extremely dangerous) routine to examine all the jobs in the queue--
  # since I don't know another way we pull all of them out and then put all of
  # them back in.
  #
  def scrub_all &block
    job_queue.connect()
    File.open("/tmp/qjobs-#{Time.now.strftime("%H%M%S")}.tsv", "w") do |dump|
    loop do
      # Kick a bunch of jobs across all connections
      $stderr.puts job_queue_stats.inspect
      kicked = job_queue.open_connections.map{|conxn| conxn.kick(20) }
      kicked = kicked.inject(0){|sum, n| sum += n }
      # For all the jobs we can get our hands on quickly,
      while(qjob = reserve_job!(0.5)) do
        # send it in for processing
        scrape_job = scrape_job_from_qjob(qjob)
        yield scrape_job
        # last recourse in case something goes wrong.
        dump << scrape_job.to_flat.join("\t")+"\n"
        # and remove it from the pool
        qjob.delete
      end
      # stop when there's no more qjobs
      break if (job_queue_total_jobs == 0) && (!job_queue.peek_ready)
    end
    end
  end
end

begin
  #
  # Catalog the jobs in the persistent store
  #
  job_store.each do |key, hsh|
    scrape_job = Twitter::Scrape::TwitterSearchJob.from_hash hsh
    periodic_log.periodically{ [scrape_job] }
    add_scrape_job scrape_job
  end

  #
  # Catalog the jobs in the transient queue
  #
  request_queue.scrub_all do |scrape_job|
    periodic_log.periodically{ [scrape_job] }
    add_scrape_job scrape_job
  end

  #
  # Import jobs from a static file
  #
  import_jobs.each_as(Twitter::Scrape::TwitterSearchJob) do |scrape_job|
    next if (scrape_job.query_term =~ /^#/) || (scrape_job.query_term.blank?)
    periodic_log.periodically{ [scrape_job] }
    add_scrape_job scrape_job
    # SCRAPES[scrape_job.query_term].priority  = scrape_job.priority  unless scrape_job.priority.blank?
    # SCRAPES[scrape_job.query_term] = scrape_job
  end
rescue Exception => e
  warn e
ensure
  #
  # Serialize them to disk
  #
  sorted = SCRAPES.sort_by{|term,scrape_job| [scrape_job.priority||65536, -(scrape_job.prev_rate||1440), term] }
  sorted.each do |term, scrape_job|
    # scrape_job.prev_rate = [scrape_job.prev_rate.to_f, 0.01].max if scrape_job.prev_rate
    # scrape_job.prev_items = 1000
    puts scrape_job.to_flat[1..-1].join("\t")
  end
end

request_queue.min_resched_delay = 10
sorted.each do |term, scrape_job|
  #
  # Persist the updated job to the job_store db, so that we can restart queue easily
  job_store.save "#{scrape_job.class}-#{scrape_job.query_term}", scrape_job.to_hash.compact

  #
  # re-enqueue the job. If it's run before, accelerate its next call; if never
  # run before schedule for immediate run.
  delay = (scrape_job.prev_rate ? request_queue.delay_to_next_scrape(scrape_job)/3 : 0)
  request_queue.save scrape_job, scrape_job.priority, delay
end
