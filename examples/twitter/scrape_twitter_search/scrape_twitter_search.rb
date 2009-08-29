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

class TwitterSearchScraper < Monkeyshines::Runner
end

#
# Create scraper
#
scraper = TwitterSearchScraper.new({
    :log     => { :iters => 1, :dest => Monkeyshines::CONFIG[:handle] },
    :source  => { :type  => :simple_request_stream },
    # :dest    => { :type  => :chunked_flat_file_store, :rootdir => WORK_DIR },
    :dest    => { :type  => :flat_file_store, :rootdir => WORK_DIR, :filename => "test_output.tsv" },
    :fetcher => { :type => :fake_fetcher },
    :sleep_time  => 0,
  })

#
# Run scraper
#
scraper.run
