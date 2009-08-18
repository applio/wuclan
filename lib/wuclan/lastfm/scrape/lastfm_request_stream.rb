require 'wuclan/lastfm/scrape/base'
module Wuclan
  module Lastfm
    module Scrape

      class LastfmRequestStream < Monkeyshines::RequestStream::KlassRequestStream
        include Wuclan::Lastfm::Scrape
        def each *args, &block
          self.request_store.each(*args) do |klass_name, hsh|
            klass = FactoryModule.get_class(Wuclan::Lastfm::Scrape, klass_name)
            yield klass.from_hash(hsh)
          end
        end

      end

    end
  end
end


# if req.is_a?(LastfmArtistShoutsRequest) then p([req.parsed_contents["shouts"]["shout"].length, req.parsed_contents["shouts"]["@attr"]]) rescue nil
# end
