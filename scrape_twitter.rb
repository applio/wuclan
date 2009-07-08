#!/usr/bin/env ruby
$: << ENV['WUKONG_PATH']
require 'wukong'
require 'wukong/utils/filename_pattern'
require 'wuclan'
require 'monkeyshines'
require 'wuclan/domains/twitter'
require 'trollop' # gem install trollop

opts = Trollop::options do
  opt :from,      "Flat file of request parameters", :type => String
  opt :type,      "Class to instantiate from each line of the --from file, e.g. --type=ShortUrlHeadRequest", :type => String
  opt :dumpfile_dir, "Filename base to store output. e.g. --dump_basename=/data/ripd", :type => String
  opt :dumpfile_pattern, "Pattern for dump file output",
    :default => ":revdom/:date/:revdom+:datetime-:pid.tsv"
end

p opts # a hash: { :monkey => false, :goat => true, :num_limbs => 4, :num_thumbs => nil }

# Request type
Trolllop::die :type, "should give the class described in the --from file" if opts[:type].blank?
request_klass = Wukong.class_from_resource(opts[:type]) or Trolllop::die(:type, "isn't a class I can instantiate")

# Request stream
Trolllop::die :from, "should give the class described in the --from file"
request_stream = FlatFileRequestStream.new(opts[:from], request_klass)

# Scraper

# Store

#
# Whee! Get each request
#
request_stream.each do |request|
  scraper.get(request) do |result|
    store.put result
  end
end
