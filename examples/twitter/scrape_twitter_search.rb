#!/usr/bin/env ruby
require 'rubygems'
require 'monkeyshines'
require 'set'
# Setup
WORK_DIR = Subdir[__FILE__,'work'].expand_path
require 'wuclan/twitter' ; include Wuclan::Twitter::Scrape
Monkeyshines.load_global_options!
Monkeyshines::CONFIG[:fetcher] = Monkeyshines::CONFIG[:twitter_api]

#
# * jobs stream from an edamame job queue.
# * each job generates 1 to 15 paginated requests, stopping when a response
#   overlaps the prev_max item.
# * Each request is fetched with the standard HTTP fetcher.
# * jobs are rescheduled based on the observed item rate
# * results are sent to a ChunkedFlatFileStore
#

class TwitterScraper < Monkeyshines::Runner
  #
  # Add an option to specify follow-on scrapes at the command line
  #
  def self.define_cmdline_options &block
    super(&block)
    yield(:source_fetches, "Follow-on requests to make. Default '#{DEFAULT_SOURCE_FETCHES.join(',')}'", :default => DEFAULT_SOURCE_FETCHES.join(','))
  end
end

#
# Create scraper
#
scraper = TwitterScraper.new({
    :log     => { :iters => 1, :dest => Monkeyshines::CONFIG[:handle] },
    :source  => { :type  => TwitterRequestStream },
    :dest    => { :type  => :chunked_flat_file_store, :rootdir => WORK_DIR },
    # :fetcher => { :type => TwitterFakeFetcher },
    :sleep_time  => 0,
  })

#
# Run scraper
#
scraper.run
