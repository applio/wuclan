#!/usr/bin/env ruby
require 'rubygems'
require 'monkeyshines'
require 'wuclan/twitter' ; include Wuclan::Twitter::Scrape
# Setup
WORK_DIR = Subdir[__FILE__,'work'].expand_path.to_s
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
  def after_fetch req
    super req
    # p [req.query_term, req.num_items, req.span, req.timespan, req.page, req.parsed_contents['next_page']]
  end
end
TwitterSearchJob.hard_request_limit = 6

#
# Create scraper
#
scraper = TwitterSearchScraper.new({
    :log     => { :iters => 1, :dest => Monkeyshines::CONFIG[:handle] },
    # :source  => { :type  => TwitterSearchStream, :klass => TwitterSearchJob },
    :source  => { :type  => TwitterSearchStream,
      :queue => { :uris => ['localhost:11240'], },
      :store => { :uri =>            ':11241',  }, },
    # :dest    => { :type  => :chunked_flat_file_store, :rootdir => WORK_DIR },
    :dest    => { :type  => :flat_file_store, :filename => WORK_DIR+"/test_output.tsv" },
    # :fetcher => { :type => TwitterSearchFakeFetcher },
    :sleep_time  => 0,
  })

#
# Run scraper
#
scraper.run
