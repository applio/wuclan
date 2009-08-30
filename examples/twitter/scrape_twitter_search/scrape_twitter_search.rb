#!/usr/bin/env ruby
require 'rubygems'
require 'monkeyshines'
require 'set'
# Setup
WORK_DIR = Subdir[__FILE__,'work'].expand_path.to_s
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
  def after_fetch req
    super req
    # p [req.query_term, req.num_items, req.span, req.timespan, req.page, req.parsed_contents['next_page']]
  end
end
TwitterSearchJob.hard_request_limit = 6

# class TwitterSearchStream < Monkeyshines::RequestStream::SimpleRequestStream
#   #
#   # for the given user_id,
#   # gets the user
#   # and then each of the requests in more_request_klasses
#   #
#   def each *args, &block
#     request_store.each do |*raw_job_args|
#       job = klass.new(*raw_job_args)
#       #  do_faking(job)
#       job.each_request(*args, &block)
#     end
#   end
# end

class TwitterSearchStream < Monkeyshines::RequestStream::EdamameQueue
  QUEUE_REQUEST_TIMEOUT = 2 # seconds
  
  def each *args, &block
    work(QUEUE_REQUEST_TIMEOUT) do |qjob|
      search_job = TwitterSearchJob.from_hash(qjob.obj)
      # do_faking(search_job)
      # p search_job
      search_job.each_request(*args, &block)
      qjob.scheduling.period = nil
    end
  end
end

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
