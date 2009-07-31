#!/usr/bin/env ruby
require 'rubygems'
require 'monkeyshines'
require 'monkeyshines/scraper/base'

#
#
#
require 'wuclan/domains/twitter'
# un-namespace request classes.
include Wuclan::Domains::Twitter::Scrape

# ===========================================================================
#
# scrape_shorturls.rb --
#
# To scrape from a list of shortened urls:
#
#    ./shorturl_random_scrape.rb --from-type=FlatFileStore --from=request_urls.tsv
#
# To do a random scrape:
#
#    ./shorturl_random_scrape.rb --from-type=RandomUrlStream --base-url=tinyurl.com
#       --base-url="http://tinyurl.com" --min-limit= --max-limit= --encoding_radix=
#
#
opts = Trollop::options do
  opt :log,            "Log file name; leave blank to use STDERR",     :type => String
  # input from file
  opt :from,           "URI for scrape store to load from",            :type => String
  opt :skip,           "Initial lines to skip",                        :type => Integer
  # output storage
  opt :cache_loc,      "URI for cache server",                         :type => String, :default => ':10022'
  opt :chunk_time,     "Frequency to rotate chunk files (in seconds)", :type => Integer, :default => 60*60*4
  opt :dest_dir,       "Filename base to store output. e.g. --dest_dir=/data/ripd", :type => String, :required => true
  opt :dest_pattern,   "Pattern for dump file output",                 :default => ":dest_dir/:handle_prefix/:handle/:date/:handle+:timestamp-:pid.tsv"

end
opts[:handle] ||= 'com.twitter'
scrape_config = YAML.load(File.open(ENV['HOME']+'/.monkeyshines'))
opts.merge! scrape_config

# ******************** Log ********************
Monkeyshines.logger = Logger.new(opts[:log], 'daily') if opts[:log]
periodic_log = Monkeyshines::Monitor::PeriodicLogger.new(:iter_interval => 10000, :time_interval => 30)

#
# ******************** Load from store ********************
#
class TwitterRequestStream < Monkeyshines::RequestStream::Base
  def each *args
    request_store.each(*args) do |twitter_user_id, *_|
      yield TwitterUserRequest.new(twitter_user_id, 1, "" )
    end
  end
end
src_store = Monkeyshines::ScrapeStore::FlatFileStore.new_from_command_line(opts, :filemode => 'r')
src_store.skip!(opts[:skip].to_i) if opts[:skip]
request_stream = TwitterRequestStore.new src_store

#
# ******************** Store output ********************
#
# Track visited URLs with key-value database
#
dest_cache = Monkeyshines::ScrapeStore::TyrantHdbKeyStore.new(opts[:cache_loc])

#
# Store the data into flat files
#
dest_pattern = Monkeyshines::Utils::FilenamePattern.new(opts[:dest_pattern], :handle => opts[:handle], :dest_dir => opts[:dest_dir])
dest_files   = Monkeyshines::ScrapeStore::ChunkedFlatFileStore.new(dest_pattern, opts[:chunk_time].to_i, opts)

#
# Conditional store uses the key-value DB to boss around the flat files --
# requests are only made (and thus data is only output) if the url is missing
# from the key-value store.
#
dest_store = Monkeyshines::ScrapeStore::ConditionalStore.new(dest_cache, dest_files)

#
# ******************** Scraper ********************
#
scraper = Monkeyshines::ScrapeEngine::HttpScraper.new opts[:twitter_api]


#
# ******************** Do this thing ********************
#
Monkeyshines.logger.info "Beginning scrape itself"
src_store.each do |req|
  # conditional store only calls scraper if url key is missing.
  result = dest_store.set(req.url) do
    response = scraper.get(req)                             # do the url fetch
    next unless response.healthy?                           # don't store bad fetches
    [response.scraped_at, response]                         # timestamp into cache, result into flat file
  end
  periodic_log.periodically{ ["%7d"%dest_store.misses, 'misses', dest_store.size, req.response_code, result, req.url] }
end
dest_store.close
scraper.close
