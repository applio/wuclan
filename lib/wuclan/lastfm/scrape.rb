require 'monkeyshines/scrape_request/raw_json_contents'
require 'wuclan/lastfm/scrape/base.rb'
module Wuclan
  module Lastfm
    module Scrape
      autoload :Base,                         'wuclan/lastfm/scrape/base.rb'
      autoload :LastfmRequestStream,          'wuclan/lastfm/scrape/lastfm_request_stream.rb'
      autoload :LastfmArtistShoutsRequest,    'wuclan/lastfm/scrape/base.rb'
      autoload :LastfmArtistTopFansRequest,   'wuclan/lastfm/scrape/base.rb'
      autoload :LastfmArtistTopTracksRequest, 'wuclan/lastfm/scrape/base.rb'
      autoload :LastfmTrackTopFansRequest,    'wuclan/lastfm/scrape/base.rb'
      autoload :LastfmUserRequest,            'wuclan/lastfm/scrape/base.rb'
    end
  end
end
