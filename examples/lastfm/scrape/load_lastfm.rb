#!/usr/bin/env ruby
require 'rubygems'
require 'monkeyshines'
WORK_DIR = Subdir[__FILE__,'work'].expand_path
include Monkeyshines

#
# Set up scrape
#
Monkeyshines.load_cmdline_options!
Monkeyshines.load_global_options!(CONFIG[:handle])
require 'wuclan/lastfm' ; include Wuclan::Lastfm::Scrape

#
# Create store
#
source = Monkeyshines::Store::FlatFileStore.new(CONFIG[:source])
dest   = Monkeyshines::RequestStream::EdamameQueue.new(
  :store => { :type => 'TyrantStore',    :uri  => ':11212'},
  :queue => { :type => 'BeanstalkQueue', :uris => ['localhost:11210'] }
  )

source.each do |klass_name, *raw_req_args|
  # Fetch basic artist info
  klass = FactoryModule.get_class(Wuclan::Lastfm::Scrape, klass_name)
  req = klass.new(Monkeyshines.url_encode(raw_req_args[0]))
  req.req_generation = 0
  dest.put req, nil, 0, 'scheduling' => Edamame::Scheduling::Every.new(4 *60*60)

  p req.to_flat
end
