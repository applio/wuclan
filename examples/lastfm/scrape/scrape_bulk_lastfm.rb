#!/usr/bin/env ruby
require 'rubygems'
require 'monkeyshines'
require 'monkeyshines/runner'
require 'wuclan/lastfm'

Monkeyshines::WORK_DIR = '/tmp'
WORK_DIR = Pathname.new(Monkeyshines::WORK_DIR).realpath.to_s

opts = Trollop::options do
  opt :log,        "Log to file instead of STDERR"
  opt :from,       "URI for scrape store to load from",            :type => String
  opt :into,       "Filename base to store output. default ./work/ripd", :default => WORK_DIR+'/ripd'
end
opts.reverse_merge!({
    :handle => 'lastfm'
  })
scrape_config = YAML.load(File.open(ENV['HOME']+'/.monkeyshines'))
opts.reverse_merge! scrape_config

# # ******************** Log ********************
# if (opts[:log])
#   opts[:log] = (WORK_DIR+'/log/'+File.basename(opts[:from],'.tsv'))
#   Monkeyshines.logger = Logger.new(opts[:log]+'.log', 'daily')
#   $stdout = $stderr = File.open(opts[:log]+"-console.log", "a")
# end

Wuclan::Lastfm::Scrape::Base.api_key = opts[:lastfm_api][:username]
class Monkeyshines::RequestStream::LastfmRequestStream < Monkeyshines::RequestStream::Base
  def request_for_params identifier, page=1
    Wuclan::Lastfm::Scrape::ArtistShoutsRequest.new identifier, page
  end
end

class LastfmRunner < Monkeyshines::Runner

  def paginated_requests
  end

  def log_line result
    if result && result.parsed_contents['shouts']['shout']
      [result.identifier, result.page, result.parsed_contents['shouts']['shout'].map{|shout| shout["author"]}.join(",")]
    end
  end
end

#
# Execute the scrape
#
scraper = LastfmRunner.new(
  :dest_store => { :type => :flat_file_store, :filename => opts[:into] },
  :request_stream => { :type => :lastfm_request_stream,
    :store => { :type => :flat_file_store, :filemode => 'r', :filename => opts[:from] } }
  )
scraper.run


  # :dest_store     => { :type => :conditional_store,
  #   :cache => { :type => :tyrant_rdb_key_store, :uri => opts[:cache_uri] },
  #   :store => { :type => :chunked_flat_file_store, :dest_dir => opts[:into] }, },
