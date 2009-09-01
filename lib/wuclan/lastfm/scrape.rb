require 'monkeyshines/scrape_request/raw_json_contents'
require 'wuclan/lastfm/scrape/base.rb'
require 'wuclan/lastfm/scrape/concrete.rb'

module Wuclan
  module Lastfm
    module Scrape
      autoload :LastfmJob,                    'wuclan/lastfm/scrape/lastfm_job.rb'
      autoload :LastfmRequestStream,          'wuclan/lastfm/scrape/lastfm_request_stream.rb'
    end
  end
end
