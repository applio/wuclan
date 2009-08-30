#!/usr/bin/env ruby
require 'rubygems'
require 'monkeyshines'
require 'monkeyshines/recursive_runner'
require 'wuclan/lastfm' ; include Wuclan::Lastfm::Scrape
# Setup
WORK_DIR = Subdir[__FILE__,'work'].expand_path
Monkeyshines.load_global_options!
Monkeyshines::CONFIG[:fetcher] = Monkeyshines::CONFIG[:lastfm_api]

#
# * jobs stream from an edamame job queue.
# * Many jobs generate paginated requests, stopping when a response overlaps the
#   prev_max item.
# * Each request is fetched with the standard HTTP fetcher.
#
# * low-generation jobs are rescheduled based on the observed item rate
# * jobs can spawn recursive requests. These have their request_generation
#   incremented
# * results are sent to a ChunkedFlatFileStore
#

#
# Create runner
#
scraper = Monkeyshines::RecursiveRunner.new({
    :log     => { :iters => 100, :dest => Monkeyshines::CONFIG[:handle] },
    :source  => { :type  => Monkeyshines::RequestStream::KlassHashRequestStream,
      :store => { :type => Monkeyshines::RequestStream::EdamameQueue,
        :queue => { :uris => ['localhost:11210'], :type => 'BeanstalkQueue', },
        :store => { :uri =>            ':11211',  :type => 'TyrantStore',    }, }, },
    :dest    => { :type  => :conditional_store,
      :cache => { :uri =>              ':11212', },
      :store => { :rootdir => WORK_DIR },},
    # :fetcher => { :type => :fake_fetcher },
    :force_fetch => false,
    :sleep_time  => 0.25, # Last.fm asks for > 0.2 please.
  })

# Execute the scrape
loop do
  puts Time.now
  scraper.run
end
