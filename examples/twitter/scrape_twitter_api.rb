#!/usr/bin/env ruby
require 'rubygems'
require 'monkeyshines'
WORK_DIR = Subdir[__FILE__,'work'].expand_path
puts WORK_DIR

#
# Set up scrape
#
require 'wuclan/twitter' ; include Wuclan::Twitter::Scrape

#
# * jobs stream from a flat file
#
# * each job generates one or several requests (ex: followers_ids,
#   friends_ids, user_timeline, favorites). Paginated requests stop when results
#   overlap the prev_max item, as tracked from a central store).
#
# * Each request is fetched with the standard HTTP fetcher.
#
# * Jobs are rescheduled based on the observed item rate
#
# * results are sent to a ChunkedFlatFileStore
#
class TwitterScraper < Monkeyshines::Runner
  def self.define_cmdline_options &block
    super(&block)
    yield(:source_fetches, "Follow-on requests to make. Default 'twitter_followers_ids,twitter_friends_ids'",
      :default => 'twitter_followers_ids,twitter_friends_ids')
  end
end

class TwitterRequestStream < Monkeyshines::RequestStream::SimpleRequestStream
  DEFAULT_REQUEST_SCOPE = Wuclan::Twitter::Scrape
  TwitterRequestStream::DEFAULT_OPTIONS = { :klass => TwitterUserRequest, }
  attr_reader :request_klasses

  def initialize _options={}
    super _options
    self.request_klasses = options[:fetches]
  end

  #
  # for the given user_id,
  # gets the user
  # and then each of the requests in more_request_klasses
  #
  def each
    request_store.each do |*raw_req_args|
      request_klasses.each do |request_klass|
        batch = request_klass.new(raw_req_args)
        batch.each_page do |req|
          yield req
          req
        end
      end
    end
  end

  #
  # Set the list of follow-on requests
  #   'followers_ids,friends_ids'
  def request_klasses=(klass_names)
    p [klass_names, DEFAULT_REQUEST_SCOPE]
    @request_klasses = FactoryModule.list_of_classes(DEFAULT_REQUEST_SCOPE, klass_names, 'request')
  end
end

class TwitterFakeFetcher < Monkeyshines::Fetcher::FakeFetcher
  def get req
    super req
    req.contents = (1..5).map{ rand(1e6) }.to_json
    req
  end
end

#
# Create runner
#
scraper = TwitterScraper.new({
    :log     => { :iters => 1, :dest => Monkeyshines::CONFIG[:handle] },
    :source  => { :type  => TwitterRequestStream,
      :store => {  } },
    :dest    => { :type  => :chunked_flat_file_store, :rootdir => WORK_DIR },
    :fetcher => { :type => TwitterFakeFetcher },
    :sleep_time  => 0.2,
  })


scraper.run
