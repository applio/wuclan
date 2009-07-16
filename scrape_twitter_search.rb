#!/usr/bin/env ruby
$: << ENV['WUKONG_PATH']
require 'wukong'
require 'monkeyshines'
require 'monkeyshines/scrape_store/flat_file_store'
require 'monkeyshines/scrape_engine/http_scraper'
require 'monkeyshines/scrape_request'
require 'monkeyshines/scrape_request/paginated'
require 'monkeyshines/scrape_request/raw_json_contents'
require 'monkeyshines/monitor/periodic_monitor'
require 'monkeyshines/request_stream/rescheduled_request_stream'
require 'trollop'
require File.dirname(__FILE__)+'/config/config_private'

#
# Command line options
#
opts = Trollop::options do
  opt :from,             "Flat file of request parameters", :type => String
  opt :dumpfile_dir,     "Filename base to store output. e.g. --dump_basename=/data/ripd", :type => String
  opt :dumpfile_pattern, "Pattern for dump file output", :default => ":revdom2/:revdom/:date/:revdom+:datetime-:pid.tsv"
end
Trollop::die :from, "should give the class described in the --from file" unless opts[:from]
Trollop::die :dumpfile_pattern unless opts[:dumpfile_pattern]

#
# ScrapeRequest for the twitter Search API.
#
# Examines the parsed contents to describe result
#
class TwitterSearchScrapeRequest < Monkeyshines::ScrapeRequest
  include Monkeyshines::RawJsonContents
  # Extract the actual search items returned
  def items
    parsed_contents['results'] if parsed_contents
  end
  # Checks that the response parses and has the right data structure.
  # if healthy? is true things should generally work
  def healthy?
    items && items.is_a?(Array)
  end
  # Number of items returned in this request
  def num_items()
    items ? items.length : 0
  end
  # Span of IDs. Assumes the response has the ids in sort order oldest to newest
  # (which the twitter API provides)
  def span
    [items.first['id'], items.last['id']] rescue nil
  end
  # Span of created_at times covered by this request.
  # Useful for rate estimation.
  def timespan
    [Time.parse(items.first['created_at']), Time.parse(items.last['created_at'])] rescue nil
  end
end

#
# ScrapeSession for the twitter Search API
#
# * Manages a series of paginated requests from first result back to last item in
#   previous scrape session.
#
#
class TwitterSearchScrapeSession < Struct.new(
    :query_term
    )
  include Monkeyshines::Paginated
  include Monkeyshines::PaginatedWithLimit
  #
  # Define API features
  #
  self.items_per_page     = 100
  self.hard_request_limit = 5
  #
  # Generate paginated TwitterSearchScrapeRequest
  #
  def make_request page, pageinfo
    url_str = "http://search.twitter.com/search.json?q=#{query_term}&rpp=#{items_per_page}"
    url_str << "&max_id=#{unscraped_span.max-1}" if unscraped_span.max
    TwitterSearchScrapeRequest.new url_str
  end

  def initialize query_term, num_items=nil, min_span=nil, max_span=nil, min_timespan=nil, max_timespan=nil
    self.num_items     = num_items.to_i
    self.prev_span     = UnionInterval.new(min_span.to_i, max_span.to_i) if min_span || max_span
    self.prev_timespan = UnionInterval.new(Time.parse(min_timespan), Time.parse(max_timespan)) rescue nil
    super(query_term)
  end
  #
  def to_flat
    [query_term, num_items, prev_span.min, prev_span.max, prev_timespan.min, prev_timespan.max].map(&:to_flat).flatten
  end
  def to_hash
    { :query_term => query_term, :num_items => num_items,
      :min_span => prev_span.min, :max_span => prev_span.max,
      :min_timespan => prev_timespan.min, :max_timespan => prev_timespan.max }
  end
end

# Queue of request sessions
scrape_sessions = Monkeyshines::FlatFileRequestStream.new(opts[:from], TwitterSearchScrapeSession)
# Scrape Store for completed requests
store    = Monkeyshines::ScrapeStore::FlatFileStore.new opts[:dumpfile_pattern]
# Scrape requests by HTTP
scraper  = Monkeyshines::ScrapeEngine::HttpScraper.new Monkeyshines::CONFIG[:twitter]
# Log every N requests
periodic_log = Monkeyshines::Monitor::PeriodicLogger.new(
  :iter_interval => 1, :time_interval => 120)
# Reschedule requests
rescheduler = Monkeyshines::RescheduledRequestStream.new(TwitterSearchScrapeSession, 150) # 3-4 pages


# scrape_sessions.each do |session|
#   next if (session.query_term =~ /^#/) || (session.query_term.blank?)
#   session.begin_pagination!
#   rescheduler << session
# end

rescheduler.each do |session|
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
rescheduler.finish

# # (1..50).map{ begin j = bs.reserve(1) ; rescue Exception => e ; warn e ; break ; end ; if j then q = j.body.gsub(/\t.*/,"") ; queries[q] ||= j.id ; if (queries[q] != j.id) then j.delete end ; j.release 65536, 45 ; puts q ; q end rescue 'error' }
