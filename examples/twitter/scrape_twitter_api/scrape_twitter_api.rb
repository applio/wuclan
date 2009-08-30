#!/usr/bin/env ruby
require 'rubygems'
require 'monkeyshines'
require 'wuclan/twitter' ; include Wuclan::Twitter::Scrape
# Setup
WORK_DIR = Subdir[__FILE__,'work'].expand_path
Monkeyshines.load_global_options!
Monkeyshines::CONFIG[:fetcher] = Monkeyshines::CONFIG[:twitter_api]

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

#
# Follow-on requests to make for each user
#
DEFAULT_SOURCE_FETCHES = [
  :user,
  :followers_ids, :friends_ids,
  # :followers, :friends, :favorites
]
#
# You can also specify these with --source-fetches on the command line
#
class TwitterScraper < Monkeyshines::Runner
  def self.define_cmdline_options &block
    super(&block)
    yield(:source_fetches, "Follow-on requests to make. Default '#{DEFAULT_SOURCE_FETCHES.join(',')}'", :default => DEFAULT_SOURCE_FETCHES.join(','))
  end
end

#
# Don't spend all day on follow-on requests
#
{ TwitterFollowersRequest => 10,
  TwitterFriendsRequest   => 10,
  TwitterFavoritesRequest => 4, }.each{|klass, limit| klass.hard_request_limit = limit }

#
# Set up scraper
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
