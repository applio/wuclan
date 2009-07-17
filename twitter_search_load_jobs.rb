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
  opt :from,             "Flat file of request parameters", :type => String
end
Trollop::die :from, "should give the class described in the --from file" unless opts[:from]

# Queue of request sessions, with reschedule requests
request_queue     = Monkeyshines::RequestStream::BeanstalkQueue.new(nil, Twitter::Scrape::Session, 100) # 3-4 pages
# Incoming requests from a flat file
scrape_sessions = Monkeyshines::RequestStream::FlatFileRequestStream.new(opts[:from], Twitter::Scrape::Session)

# Scrape Store for completed requests
store           = Monkeyshines::ScrapeStore::FlatFileStore.new opts[:dumpfile_pattern]
# Scrape requests by HTTP
scraper         = Monkeyshines::ScrapeEngine::HttpScraper.new Monkeyshines::CONFIG[:twitter]
# Log every N requests
periodic_log    = Monkeyshines::Monitor::PeriodicLogger.new(:iter_interval => 100, :time_interval => 10)

# # Persist session jobs in distributed DB
# store   = Monkeyshines::ScrapeStore::ReadThruStore.new_from_command_line opts

Twitter::Scrape::Session.hard_request_limit = 5

SCRAPES = { }

def add_session session
  if SCRAPES[session.query_term] &&
      (SCRAPES[session.query_term].prev_items.to_i >= session.prev_items.to_i)
    # warn "Already have #{session.query_term}: #{SCRAPES[session.query_term]}"
    return
  end
  SCRAPES[session.query_term] = session
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
      while(job = reserve_job!(0.5)) do
        # archive the job under its query term
        session = new_request_from_job(job)
        add_session session
        $stderr.puts session.to_flat[1..-1].join("\t")
        # and remove it from the pool
        job.delete
      end
      # stop when there's no more jobs
      break if (job_queue_total_jobs == 0) && (!job_queue.peek_ready)
    end
  end
end

begin
request_queue.scrub_all{}
scrape_sessions.each do |session|
  next if (session.query_term =~ /^#/) || (session.query_term.blank?)
  periodic_log.periodically{ [session] }
  add_session session
end
rescue Exception => e
  warn e
ensure
  sorted = SCRAPES.sort_by{|term,session| [session.priority||65536, -(session.prev_rate||1440), term] }
  sorted.each do |term, session|
    puts session.to_flat[1..-1].join("\t")
  end
end

request_queue.min_resched_delay = 30
sorted.each do |term, session|
  request_queue.save session, session.priority, (session.prev_rate ? nil : 0) rescue nil
end

# # Run through all pages for this search term
# session.each_request do |req|
#   # Make request
#   response = scraper.get(req)
#   periodic_log.periodically{ [session] }
#   response
# end
# puts [
#   "%7.3f"%(60*avg_rate),
#   "%7.3f"%(60*sess_rate.to_f), sess_items,
#   "%7.3f"%(60*prev_rate.to_f), prev_items, (60*response.num_items / UnionInterval.new(*response.timespan).size.to_f),
#   $foo.delay_to_next_scrape(self).to_f / 60
# ].join("\t")
