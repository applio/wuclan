require 'wuclan/friendster/scrape/base'
module Wuclan
  module Friendster
    module Scrape


      class FriendsterRequestStream < Monkeyshines::RequestStream::KlassRequestStream
        include Wuclan::Friendster::Scrape
        cattr_accessor :requestables
        self.requestables = [
        ]
        def each *args, &block
          self.request_store.each(*args) do |klass, *raw_req_args|
            # Fetch basic artist info
            artist = LastfmArtistInfoRequest.new(*raw_req_args)
            yield artist
            next unless artist.healthy?
            # Request remaining artist requests
            requestables.each do |klass|
              req = klass.new(artist.identifier)
              yield req
              req.recursive_requests do |req|
                yield req
                break if (! req.healthy?) || (page > 4)
              end
            end
          end
        end
      end

    end
  end
end


# if req.is_a?(LastfmArtistShoutsRequest) then p([req.parsed_contents["shouts"]["shout"].length, req.parsed_contents["shouts"]["@attr"]]) rescue nil
# end
