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
require 'wuclan/twitter' ; include Wuclan::Twitter::Scrape

#
# Create runner
#
scraper = Monkeyshines::RecursiveRunner.new({
    :log     => { :iters => 1, :dest => Monkeyshines::CONFIG[:handle] },
    :source  => { :type  => Monkeyshines::RequestStream::KlassHashRequestStream,
      :store => { :type => Monkeyshines::RequestStream::EdamameQueue,
        :store => { :uri =>            ':11232',  :type => 'TyrantStore',    },
        :queue => { :uris => ['localhost:11230'], :type => 'BeanstalkQueue', } }, },
    # :fetcher => { :type => :fake_fetcher },
    :sleep_time  => 1,
  })

# Execute the scrape
loop do
  scraper.run
end
