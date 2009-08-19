require 'wuclan/lastfm/scrape/base'
module Wuclan
  module Lastfm
    module Scrape

      class LastfmRequestStream < Monkeyshines::RequestStream::KlassRequestStream
        include Wuclan::Lastfm::Scrape

      end

    end
  end
end


# if req.is_a?(LastfmArtistShoutsRequest) then p([req.parsed_contents["shouts"]["shout"].length, req.parsed_contents["shouts"]["@attr"]]) rescue nil
# end
