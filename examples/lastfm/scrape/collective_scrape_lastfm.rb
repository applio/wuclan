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
        :store => { :uri =>            ':11212',  :type => 'TyrantStore',    },
        :queue => { :uris => ['localhost:11210'], :type => 'BeanstalkQueue', } }, },
    :dest    => { :type  => :conditional_store,
      :cache => { :uri =>              ':11213', },
      :store => { :rootdir => WORK_DIR },},
    # :fetcher => { :type => :fake_fetcher },
    :force_fetch => false,
    :sleep_time  => 0.2,
  })

# Execute the scrape
loop do
  puts Time.now
  scraper.run
end
