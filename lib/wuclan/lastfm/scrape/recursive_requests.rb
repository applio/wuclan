require 'monkeyshines/scrape_request/raw_json_contents'
module Wuclan
  module Lastfm
    module Scrape

      #
      # Simple requestables
      #

      class LastfmArtistInfoRequest
        self.requestables = [
          LastfmArtistSimilarRequest,
          LastfmArtistTopAlbumsRequest,
          LastfmArtistTopTracksRequest,
          LastfmArtistShoutsRequest,
          LastfmArtistEventsRequest,
          LastfmArtistTopFansRequest,
          # LastfmArtistTopTagsRequest, LastfmArtistImagesRequest, LastfmArtistPodcastRequest,
        ]
      end

      class LastfmTrackInfoRequest
        self.requestables = [LastfmTrackSimilarRequest, LastfmTrackTopFansRequest, LastfmTrackTopTagsRequest]
      end
      class LastfmEventInfoRequest
        self.requestables = [LastfmEventAttendeesRequest, LastfmEventShoutsRequest]
      end
      class LastfmUserTopTagsRequest # LastfmUserInfoRequest
        self.requestables = [
          # LastfmUserTopTagsRequest,
          LastfmUserEventsRequest,
          LastfmUserPastEventsRequest,
          LastfmUserFriendsRequest, # recenttracks
          LastfmUserNeighboursRequest,
          LastfmUserLovedTracksRequest,
          LastfmUserRecentTracksRequest,
          LastfmUserShoutsRequest,
          LastfmUserTopAlbumsRequest,    # period (Optional) : overall | 7day | 3month | 6month | 12month
          LastfmUserTopArtistsRequest,   # period (Optional) : overall | 7day | 3month | 6month | 12month
          LastfmUserTopTracksRequest,    # period (Optional) : overall | 7day | 3month | 6month | 12month
          # uninteresting(?): LastfmUserPlaylistsRequest, LastfmUserWeeklyAlbumChartRequest, LastfmUserWeeklyArtistChartRequest, LastfmUserWeeklyChartListRequest, LastfmUserWeeklyTrackChartRequest,
          # needs auth:       LastfmUserInfoRequest, LastfmUserRecentStationsRequest, LastfmUserRecommendedArtistsRequest, LastfmUserRecommendedEventsRequest,
        ]
      end

      #
      # Recursive requests based on contents
      #

      module LastfmTimeWindowed
        def recursive_requests *args, &block
          super(*args, &block)
          unless (identifier =~ /&period=/)
            ['7day', '3month', '6month'].each do |period|
              req = self.class.new(identifier+"&period=#{period}")
              req.generation = generation.to_i
              yield req
            end
          end
        end
      end
      [LastfmUserTopArtistsRequest, LastfmUserTopAlbumsRequest, LastfmUserTopTracksRequest
      ].each do |klass|
        klass.class_eval do include LastfmTimeWindowed ; end
      end

      module LastfmContainsArtists
        def recursive_requests *args, &block
          super(*args, &block)
          items.each do |artist|
            req = LastfmArtistInfoRequest.new(url_encode(artist['name']))
            req.generation = generation.to_i + 1
            yield req
          end
        end
      end
      [ LastfmArtistSimilarRequest, LastfmGeoTopArtistsRequest, LastfmTagTopArtistsRequest,
        LastfmUserRecommendedArtistsRequest, LastfmUserTopArtistsRequest,
      ].each do |klass|
        klass.class_eval do include LastfmContainsArtists ; end
      end

      module LastfmContainsAlbums
        def recursive_requests *args, &block
          super(*args, &block)
          items.each do |item|
            obj_artist = item['artist']['name'] || item['artist']['#text'] rescue nil
            req = LastfmAlbumInfoRequest.from_identifier_hash(
              item['name'], :artist => obj_artist, :mbid => item['mbid'] )
            req.generation = generation.to_i + 1
            yield req
          end
        end
      end
      [ LastfmArtistTopAlbumsRequest, LastfmTagTopAlbumsRequest, LastfmUserTopAlbumsRequest,
      ].each do |klass|
        klass.class_eval do include LastfmContainsAlbums ; end
      end

      module LastfmContainsTracks
        def recursive_requests *args, &block
          super(*args, &block)
          items.each do |track|
            obj_artist = track['artist']['name'] || track['artist']['#text'] rescue nil
            req = LastfmTrackInfoRequest.from_identifier_hash(
              track['name'], :artist => obj_artist, :mbid => track['mbid'])
            req.generation = generation.to_i + 1
            yield req
          end
        end
      end
      [ LastfmArtistTopTracksRequest, LastfmGeoTopTracksRequest,    LastfmTagTopTracksRequest,
        LastfmTrackSimilarRequest,    LastfmUserLovedTracksRequest, LastfmUserRecentTracksRequest,
        LastfmUserTopTracksRequest,
      ].each do |klass|
        klass.class_eval do include LastfmContainsTracks ; end
      end

      module LastfmContainsEvents
        def recursive_requests *args, &block
          super(*args, &block)
          items.each do |event|
            req = LastfmEventInfoRequest.new(event['id'])
            req.generation = generation.to_i + 1
            yield req
          end
        end
      end
      [ LastfmArtistEventsRequest, LastfmGeoEventsRequest, LastfmUserEventsRequest,
        LastfmUserPastEventsRequest, LastfmUserRecommendedEventsRequest, LastfmVenueEventsRequest,
        LastfmVenuePastEventsRequest,
      ].each do |klass|
        klass.class_eval do include LastfmContainsEvents ; end
      end

      module LastfmContainsUsers
        def recursive_requests *args, &block
          super(*args, &block)
          items.each do |user|
            req = LastfmUserTopTagsRequest.new(url_encode(user['name']))
            req.generation = generation.to_i + 1
            yield req
          end
        end
      end
      [ LastfmArtistTopFansRequest, LastfmEventAttendeesRequest, LastfmGroupMembersRequest,
        LastfmTrackTopFansRequest,  LastfmUserFriendsRequest,    LastfmUserNeighboursRequest,
      ].each do |klass|
        klass.class_eval do include LastfmContainsUsers ; end
      end

    end
  end
end
