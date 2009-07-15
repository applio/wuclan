#!/usr/bin/env ruby
$: << ENV['WUKONG_PATH']
require 'wukong'
require 'monkeyshines'
require 'monkeyshines/scrape_store/read_thru_store'
require 'monkeyshines/scrape_engine/http_scraper'
require 'monkeyshines/scrape_request'
require 'monkeyshines/scrape_request/paginated'
require 'monkeyshines/scrape_request/raw_json_contents'
require 'trollop'
require File.dirname(__FILE__)+'/config/config_private'
opts = Trollop::options do
  opt :from,             "Flat file of request parameters", :type => String
  opt :dumpfile_dir,     "Filename base to store output. e.g. --dump_basename=/data/ripd", :type => String
  opt :dumpfile_pattern, "Pattern for dump file output", :default => ":revdom2/:revdom/:date/:revdom+:datetime-:pid.tsv"
end

class TwitterSearchRequest < Monkeyshines::ScrapeRequest
  include Monkeyshines::RawJsonContents
  def items
    parsed_contents['results']
  end
  def healthy?
    items && items.is_a?(Array)
  end

  def num_items()
    items ? items.length : 0
  end
  def id_span
    [items.first['id'], items.last['id']] rescue nil
  end
  def time_span
    [Time.parse(items.first['created_at']), Time.parse(items.last['created_at'])] rescue nil
  end

end

class TwitterSearchScrapable < Struct.new(
    :query_term
    )
  include Monkeyshines::Paginated #WithLimit
  self.items_per_page = 100
  self.max_pages      = 15

  def initialize *args
    super *args
    begin_pagination!
  end

  # "since_id":0,
  # "max_id":1480307926,
  # "refresh_url":"?since_id=1480307926&q=%40twitterapi",
  # "next_page":"?page=2&max_id=1480307926&q=%40twitterapi",
  def make_request page, pageinfo
    url_str = "http://search.twitter.com/search.json?q=#{query_term}&rpp=#{items_per_page}"
    url_str << "&max_id=#{unscraped_id_span.max-1}" if unscraped_id_span.max
    #url_str << "&page=#{page}"                      if page.to_i > 0
    TwitterSearchRequest.new url_str
  end
end

class RescheduledRequestStream < Monkeyshines::FlatFileRequestStream
  def file
    @file ||= $stdout
  end
  def <<(val)
    file << val
  end
end

# Request stream
Trollop::die :from, "should give the class described in the --from file" unless opts[:from]
search_term_scrapables = Monkeyshines::FlatFileRequestStream.new(opts[:from], TwitterSearchScrapable)

# Reschedule next requests
#rescheduled_requests = Monkeyshines::FlatFileRequestStream.new(opts[:reschedule_into], TwitterSearchScrapable, :writeable => true)
rescheduled_requests = RescheduledRequestStream.new('', TwitterSearchScrapable, :writeable => true)

# # Scrape Store
# store   = Monkeyshines::ScrapeStore::FlatFileStore.new_from_command_line opts

# Scraper
scraper = Monkeyshines::ScrapeEngine::HttpScraper.new Monkeyshines::CONFIG[:twitter]

#
search_term_scrapables.each do |search_term_scrapable|
  next if (search_term_scrapable.query_term =~ /^#/) || (search_term_scrapable.query_term.blank?)
  # search_term_scrapable.prev_id_span.max = 2530000000
  search_term_scrapable.each_page do |req|
    response = scraper.get(req)
    #   if response
    #     # save the response
    #     store.save response
    #   end
    response
  end

  # # store completed request with updated min_id
  # completed_requests << search_term_request
end
