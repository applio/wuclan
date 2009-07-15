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
  opt :from,      "Flat file of request parameters", :type => String
  opt :type,      "Class to instantiate from each line of the --from file, e.g. --type=ShortUrlHeadRequest", :type => String
  opt :dumpfile_dir, "Filename base to store output. e.g. --dump_basename=/data/ripd", :type => String
  opt :dumpfile_pattern, "Pattern for dump file output",
    :default => ":revdom/:date/:revdom+:datetime-:pid.tsv"
end

class TwitterSearchRequest < Monkeyshines::ScrapeRequest
  include Monkeyshines::RawJsonContents
  def items
    parsed_contents['results']
  end
end

class TwitterSearchScrapable < Struct.new(:query_term,
    :first_item_id, :last_item_id,
    :first_item_at, :last_item_at, :num_items
    )
  include Monkeyshines::Paginated #WithLimit
  self.items_per_page = 100
  self.max_pages      = 2
  attr_accessor :max_id

  def initialize *args
    super *args
    self.num_items ||= 0
  end

  def acknowledge response
    return unless response && response.items
    self.num_items += response.items.length
    if (first_item = response.items.first)
      self.first_item_at ||= Time.parse(first_item['created_at'])
      self.first_item_id ||= first_item['id']
    end
    if (last_item = response.items.last)
      self.last_item_at    = Time.parse(last_item['created_at'])
      self.last_item_id    = last_item['id']
    end
  end

  # "since_id":0,
  # "max_id":1480307926,
  # "refresh_url":"?since_id=1480307926&q=%40twitterapi",
  # "next_page":"?page=2&max_id=1480307926&q=%40twitterapi",
  def make_request page, pageinfo
    url_str = "http://search.twitter.com/search.json?q=#{query_term}&rpp=#{items_per_page}"
    url_str << "&max_id=#{max_id}"   if max_id
    url_str << "&page=#{page}"       if page.to_i > 0
    # url_str << "&since_id=#{min_id}" if min_id
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
  search_term_scrapable.each_page do |req|
    response = scraper.get(req)
    #   if response
    #     # save the response
    #     store.save response
    #   end
  end

  # # store completed request with updated min_id
  # completed_requests << search_term_request
end
