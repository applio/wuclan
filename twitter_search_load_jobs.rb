#!/usr/bin/env ruby
$: << ENV['WUKONG_PATH']
require File.dirname(__FILE__)+'/config/config_private'
require 'rubygems'
require 'trollop'
require 'wukong'
require 'monkeyshines'
#
require 'wuclan/domains/twitter/scrape' ; include Wuclan::Domains
require 'monkeyshines/scrape_engine/http_scraper'

#
# Command line options
#
opts = Trollop::options do
  opt :from,             "Flat file of request parameters",                   :type => String
  opt :store_db,        "Tokyo cabinet db name",                              :type => String
end
Trollop::die :from, "should give the class described in the --from file" unless opts[:from]

# Queue of request scrape_jobs, with reschedule requests
request_queue     = Monkeyshines::RequestStream::BeanstalkQueue.new(nil, Twitter::Scrape::TwitterSearchJob, 100) # 3-4 pages
# Incoming requests from a flat file
scrape_jobs = Monkeyshines::RequestStream::FlatFileRequestStream.new(opts[:from], Twitter::Scrape::TwitterSearchJob)

# Scrape Store for completed requests
store           = Monkeyshines::ScrapeStore::FlatFileStore.new opts[:dumpfile_pattern]
# Scrape requests by HTTP
scraper         = Monkeyshines::ScrapeEngine::HttpScraper.new Monkeyshines::CONFIG[:twitter]
# Log every N requests
periodic_log    = Monkeyshines::Monitor::PeriodicLogger.new(:iter_interval => 100, :time_interval => 10)

# Persist scrape_job jobs in distributed DB
job_store   = Monkeyshines::ScrapeStore::KeyStore.new_from_command_line opts

Twitter::Scrape::TwitterSearchJob.hard_request_limit = 5

SCRAPES = { }

def add_scrape_job scrape_job
  if SCRAPES[scrape_job.query_term] &&
      (SCRAPES[scrape_job.query_term].prev_items.to_i >= scrape_job.prev_items.to_i)
    # warn "Already have #{scrape_job.query_term}: #{SCRAPES[scrape_job.query_term]}"
    return
  end
  SCRAPES[scrape_job.query_term] = scrape_job
end


Monkeyshines::RequestStream::BeanstalkQueue.class_eval do
  def job_queue_stats
    job_queue.stats.select{|k,v| k =~ /jobs/} # .reject{|k,v| k=~/^cmd-/}
  end
  def job_queue_total_jobs
    stats = job_queue.stats
    [:reserved, :ready, :buried, :delayed].inject(0){|sum,type| sum += stats["current-jobs-#{type}"]}
  end
  def scrub_all &block
    job_queue.connect()
    loop do
      # Kick a bunch of jobs across all connections
      $stderr.puts job_queue_stats.inspect
      kicked = job_queue.open_connections.map{|conxn| conxn.kick(20) }
      kicked = kicked.inject(0){|sum, n| sum += n }
      # For all the jobs we can get our hands on quickly,
      while(qjob = reserve_job!(0.5)) do
        scrape_job = scrape_job_from_qjob(qjob)
        yield scrape_job
        # and remove it from the pool
        qjob.delete
      end
      # stop when there's no more qjobs
      break if (job_queue_total_jobs == 0) && (!job_queue.peek_ready)
    end
  end
end

begin
  request_queue.scrub_all do |scrape_job|
    # archive the job under its query term
    add_scrape_job scrape_job
    $stderr.puts scrape_job.to_flat[1..-1].join("\t")
  end
  scrape_jobs.each do |scrape_job|
    next if (scrape_job.query_term =~ /^#/) || (scrape_job.query_term.blank?)
    periodic_log.periodically{ [scrape_job] }
    add_scrape_job scrape_job
  end
  job_store.each do |hsh|
    scrape_job = Twitter::Scrape::TwitterSearchJob.from_hash hsh
    periodic_log.periodically{ [scrape_job] }
    add_scrape_job scrape_job
  end
rescue Exception => e
  warn e
ensure
  sorted = SCRAPES.sort_by{|term,scrape_job| [scrape_job.priority||65536, -(scrape_job.prev_rate||1440), term] }
  sorted.each do |term, scrape_job|
    puts scrape_job.to_flat[1..-1].join("\t")
    job_store.save "#{scrape_job.class}-#{scrape_job.query_term}", scrape_job
  end
end

request_queue.min_resched_delay = 10
sorted.each do |term, scrape_job|
  request_queue.save scrape_job, scrape_job.priority, (scrape_job.prev_rate ? nil : 0) rescue nil
end

