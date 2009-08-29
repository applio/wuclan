#!/usr/bin/env ruby
require 'rubygems'
require 'monkeyshines'
WORK_DIR = Subdir[__FILE__,'work'].expand_path
puts WORK_DIR

#
# Set up scrape
#
Monkeyshines.load_cmdline_options!
Monkeyshines.load_global_options!(Monkeyshines::CONFIG[:handle])
require 'wuclan/twitter' ; include Wuclan::Twitter::Scrape

#
# * jobs stream from an edamame job queue.
# * each job generates 1 to 15 paginated requests, stopping when a response
#   overlaps the prev_max item.
# * Each request is fetched with the standard HTTP fetcher.
# * jobs are rescheduled based on the observed item rate
# * results are sent to a ChunkedFlatFileStore
#

# Execute the scrape forever
loop do
  scraper.run
end
