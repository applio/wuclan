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

class TwitterSearchStream < Monkeyshines::RequestStream::SimpleRequestStream
  
  # def do_faking job
  #   TwitterSearchFakeFetcher.items_rate = job.prev_rate || 1
  #   job.prev_span_max = (TwitterSearchFakeFetcher.fake_time(rand(15) * 105)*100).to_i
  #   p [
  #     job.prev_span_max,
  #     TwitterSearchFakeFetcher.fake_time(0).to_i
  #   ]
  # end
  
  #
  # for the given user_id,
  # gets the user
  # and then each of the requests in more_request_klasses
  #
  def each *args, &block
    request_store.each do |*raw_job_args|
      job = klass.new(*raw_job_args)
      #  do_faking(job)
      job.each_request(*args, &block)
    end
  end
end


class TwitterSearchFakeFetcher < Monkeyshines::Fetcher::FakeFetcher
  cattr_accessor :items_rate
  def self.fake_time item_on_page, base=nil
    base ||= 86_400
    base - (item_on_page.to_f / items_rate)
  end
  
  def fake_contents req
    max_time = self.class.fake_time((req.page - 1) * 105)
    max_id   = max_time.to_i
    case req.query_term
    when '_no_results'
      return { :max_id => -1, :results => [],}
    when '_one_result'
      n_results = 1
    else
      n_results = 100
    end
    { :max_id    => max_id,
      # :next_page => "?page=2&max_id=#{max_id}&rpp=100&q=#{req.query_term}",
      :results   => (0 ... n_results).map{|i| {
          :text       => "%s-%04d-%03d"%[req.query_term, req.page, i],
          :created_at => Time.now - (86_400 - self.class.fake_time(i, max_time)),
          :id         => (self.class.fake_time(i, max_id)*100).to_i } }   }
  end
  
  def get req
    super req
    req.contents = fake_contents(req).to_json
    req
  end
end


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
    :source  => { :type  => TwitterSearchStream, :klass => TwitterSearchJob }, 
    # :dest    => { :type  => :chunked_flat_file_store, :rootdir => WORK_DIR },
    :dest    => { :type  => :flat_file_store, :filename => WORK_DIR+"/test_output.tsv" },
    # :fetcher => { :type => TwitterSearchFakeFetcher },
    :sleep_time  => 0,
  })

#
# Run scraper
#
scraper.run
