#!/usr/bin/env ruby
require 'rubygems'
require 'monkeyshines'
require 'monkeyshines/recursive_runner'
WORK_DIR = Subdir[__FILE__,'work'].expand_path
puts WORK_DIR

#
# Set up scrape
#
Monkeyshines.load_cmdline_options!
Monkeyshines.load_global_options!(Monkeyshines::CONFIG[:handle])
require 'wuclan/lastfm' ; include Wuclan::Lastfm::Scrape

#
# Create runner
#
scraper = Monkeyshines::RecursiveRunner.new({
    :log     => { :iters => 100, :dest => Monkeyshines::CONFIG[:handle] },
    :source  => { :type  => Monkeyshines::RequestStream::KlassHashRequestStream,
      :store => { :type => Monkeyshines::RequestStream::EdamameQueue,
        :store => { :type => 'TyrantStore',    :uri => ':11212'},
        :queue => { :type => 'BeanstalkQueue', :uris => ['localhost:11210'] } }, },
    :dest    => { :type  => :conditional_store,
      :store => { :rootdir => WORK_DIR },
      :cache => { :uri => ':11222'     }, },
    # :fetcher => { :type => :fake_fetcher },
    :force_fetch => false,
    :sleep_time  => 0.25,
  })

# Execute the scrape
scraper.run
