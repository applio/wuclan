require 'monkeyshines/scrape_request/raw_json_contents'
module Wuclan
  module Lastfm
    module Scrape

      #
      # Base class for Lastfm API requests
      #
      class Base < TypedStruct.new(
          [:identifier,       Integer],
          [:page,             Integer],
          [:moreinfo,         String],
          [:url,              String],
          [:scraped_at,       Bignum],
          [:response_code,    Integer],
          [:response_message, String],
          [:contents,         String]
          )
        # Basic ScrapeRequest functionality
        include Monkeyshines::ScrapeRequestCore
        # Contents are JSON
        include Monkeyshines::RawJsonContents
        # Paginated
        class_inheritable_accessor :resource_path, :page_limit, :items_per_page
        self.items_per_page = 50

        # API
        cattr_accessor :api_key
        self.api_key = Monkeyshines::CONFIG[:api_key] rescue nil
        #
        def initialize *args
          super *args
          self.page = (page.to_i < 1 ? 1 : page.to_i)
          make_url! if (! url)
        end

        #
        # Generate request URL from other attributes
        def make_url
          # This works for most of the twitter calls
          "http://ws.audioscrobbler.com/2.0/?method=#{resource_path}#{identifier}&limit=#{items_per_page}&page=#{page}&api_key=#{api_key}&format=json"
        end

        def healthy?
          super && ( (contents !~ %r{^\{"error":}) )
        end

        def main_fieldname
          resource_path.gsub(/.*\.get(\w+)&.*/, '\1')
        end
        def main_result
          return @main_result if @main_result
          return unless healthy?
          @main_result = parsed_contents[main_fieldname] rescue nil
        end

        def result_attrs
          main_result["@attr"] rescue nil
        end

        def num_pages
          attrs = result_attrs
          return 1 if (attrs.blank? || attrs['totalPages'].blank?)
          attrs['totalPages'].to_i.clamp(1,5)
        end

        #
        # For parsing, note the different form for empty responses.
        #
      end

      class LastfmAlbumInfoRequest              < Base ; self.resource_path = 'album.getinfo&album='              ; end
      class LastfmAlbumTagsRequest              < Base ; self.resource_path = 'album.gettags&album='              ; end
      class LastfmArtistEventsRequest           < Base ; self.resource_path = 'artist.getevents&artist='          ; end
      class LastfmArtistImagesRequest           < Base ; self.resource_path = 'artist.getimages&artist='          ; end
      class LastfmArtistInfoRequest             < Base ; self.resource_path = 'artist.getinfo&artist='            ; end
      class LastfmArtistPodcastRequest          < Base ; self.resource_path = 'artist.getpodcast&artist='         ; end
      class LastfmArtistShoutsRequest           < Base ; self.resource_path = 'artist.getshouts&artist='          ; end
      class LastfmArtistSimilarRequest          < Base ; self.resource_path = 'artist.getsimilar&artist='         ; end
      class LastfmArtistTagsRequest             < Base ; self.resource_path = 'artist.gettags&artist='            ; end
      class LastfmArtistTopAlbumsRequest        < Base ; self.resource_path = 'artist.gettopalbums&artist='       ; end
      class LastfmArtistTopFansRequest          < Base ; self.resource_path = 'artist.gettopfans&artist='         ; end
      class LastfmArtistTopTagsRequest          < Base ; self.resource_path = 'artist.gettoptags&artist='         ; end
      class LastfmArtistTopTracksRequest        < Base ; self.resource_path = 'artist.gettoptracks&artist='       ; end
      class LastfmEventAttendeesRequest         < Base ; self.resource_path = 'event.getattendees&event='         ; end
      class LastfmEventInfoRequest              < Base ; self.resource_path = 'event.getinfo&event='              ; end
      class LastfmEventShoutsRequest            < Base ; self.resource_path = 'event.getshouts&event='            ; end
      class LastfmGeoEventsRequest              < Base ; self.resource_path = 'geo.getevents&geo='                ; end
      class LastfmGeoTopArtistsRequest          < Base ; self.resource_path = 'geo.gettopartists&geo='            ; end
      class LastfmGeoTopTracksRequest           < Base ; self.resource_path = 'geo.gettoptracks&geo='             ; end
      class LastfmGroupMembersRequest           < Base ; self.resource_path = 'group.getmembers&group='           ; end
      class LastfmGroupWeeklyAlbumChartRequest  < Base ; self.resource_path = 'group.getweeklyalbumchart&group='  ; end
      class LastfmGroupWeeklyArtistChartRequest < Base ; self.resource_path = 'group.getweeklyartistchart&group=' ; end
      class LastfmGroupWeeklyChartListRequest   < Base ; self.resource_path = 'group.getweeklychartlist&group='   ; end
      class LastfmGroupWeeklyTrackChartRequest  < Base ; self.resource_path = 'group.getweeklytrackchart&group='  ; end
      class LastfmPlaylistfetchRequest          < Base ; self.resource_path = 'playlist.fetch&playlist='          ; end
      class LastfmTagSimilarRequest             < Base ; self.resource_path = 'tag.getsimilar&tag='               ; end
      class LastfmTagTopAlbumsRequest           < Base ; self.resource_path = 'tag.gettopalbums&tag='             ; end
      class LastfmTagTopArtistsRequest          < Base ; self.resource_path = 'tag.gettopartists&tag='            ; end
      class LastfmTagTopTagsRequest             < Base ; self.resource_path = 'tag.gettoptags&tag='               ; end
      class LastfmTagTopTracksRequest           < Base ; self.resource_path = 'tag.gettoptracks&tag='             ; end
      class LastfmTagWeeklyArtistChartRequest   < Base ; self.resource_path = 'tag.getweeklyartistchart&tag='     ; end
      class LastfmTagWeeklyChartListRequest     < Base ; self.resource_path = 'tag.getweeklychartlist&tag='       ; end
      class LastfmTasteometercompareRequest     < Base ; self.resource_path = 'tasteometer.compare&tasteometer='  ; end
      class LastfmTrackInfoRequest              < Base ; self.resource_path = 'track.getinfo&track='              ; end
      class LastfmTrackSimilarRequest           < Base ; self.resource_path = 'track.getsimilar&track='           ; end
      class LastfmTrackTagsRequest              < Base ; self.resource_path = 'track.gettags&track='              ; end
      class LastfmTrackTopFansRequest           < Base ; self.resource_path = 'track.gettopfans&track='           ; end
      class LastfmTrackTopTagsRequest           < Base ; self.resource_path = 'track.gettoptags&track='           ; end
      class LastfmUserEventsRequest             < Base ; self.resource_path = 'user.getevents&user='              ; end
      class LastfmUserFriendsRequest            < Base ; self.resource_path = 'user.getfriends&recenttracks=1&user='             ; end
      class LastfmUserInfoRequest               < Base ; self.resource_path = 'user.getinfo&user='                ; end
      class LastfmUserLovedTracksRequest        < Base ; self.resource_path = 'user.getlovedtracks&user='         ; end
      class LastfmUserNeighboursRequest         < Base ; self.resource_path = 'user.getneighbours&user='          ; end
      class LastfmUserPastEventsRequest         < Base ; self.resource_path = 'user.getpastevents&user='          ; end
      class LastfmUserPlaylistsRequest          < Base ; self.resource_path = 'user.getplaylists&user='           ; end
      class LastfmUserRecentStationsRequest     < Base ; self.resource_path = 'user.getrecentstations&user='      ; end
      class LastfmUserRecentTracksRequest       < Base ; self.resource_path = 'user.getrecenttracks&user='        ; end
      class LastfmUserRecommendedArtistsRequest < Base ; self.resource_path = 'user.getrecommendedartists&user='  ; end
      class LastfmUserRecommendedEventsRequest  < Base ; self.resource_path = 'user.getrecommendedevents&user='   ; end
      class LastfmUserShoutsRequest             < Base ; self.resource_path = 'user.getshouts&user='              ; end
      class LastfmUserTopAlbumsRequest          < Base ; self.resource_path = 'user.gettopalbums&user='           ; end
      class LastfmUserTopArtistsRequest         < Base ; self.resource_path = 'user.gettopartists&user='          ; end
      class LastfmUserTopTagsRequest            < Base ; self.resource_path = 'user.gettoptags&user='             ; end
      class LastfmUserTopTracksRequest          < Base ; self.resource_path = 'user.gettoptracks&user='           ; end
      class LastfmUserWeeklyAlbumChartRequest   < Base ; self.resource_path = 'user.getweeklyalbumchart&user='    ; end
      class LastfmUserWeeklyArtistChartRequest  < Base ; self.resource_path = 'user.getweeklyartistchart&user='   ; end
      class LastfmUserWeeklyChartListRequest    < Base ; self.resource_path = 'user.getweeklychartlist&user='     ; end
      class LastfmUserWeeklyTrackChartRequest   < Base ; self.resource_path = 'user.getweeklytrackchart&user='    ; end
      class LastfmVenueEventsRequest            < Base ; self.resource_path = 'venue.getevents&venue='            ; end
      class LastfmVenuePastEventsRequest        < Base ; self.resource_path = 'venue.getpastevents&venue='        ; end


      Base.class_eval do
        class_inheritable_accessor :requestables
        self.requestables = []
        def recursive_requests &block
          return unless healthy?
          #
          # Pages
          #
          if (num_pages >= 2) && (self.page.to_i < 2)
            (2 .. num_pages).each do |page|
              req = self.class.new(identifier, page)
              req.req_generation = req_generation.to_i
              yield req
            end
          end
          #
          # requestables
          #
          requestables.each do |klass|
            req = klass.new(identifier)
            req.req_generation = req_generation.to_i + 1
            yield req
          end
        end
      end

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
      class LastfmArtistSimilarRequest ; def main_fieldname() 'similarartists' end ; end
      class LastfmTrackSimilarRequest  ; def main_fieldname() 'similartracks'  end ; end

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
      module LastfmTimeWindowed
        def recursive_requests *args, &block
          super(*args, &block)
          unless (identifier =~ /&period=/)
            ['7day', '3month', '6month'].each do |period|
              req = self.class.new(identifier+"&period=#{period}")
              req.req_generation = req_generation.to_i
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
          super(*args, &block) ; return unless main_result
          artists = main_result['artist'] or return
          [artists].flatten.compact.each do |artist|
            req = LastfmArtistInfoRequest.new(url_encode(artist['name']))
            req.req_generation = req_generation.to_i + 1
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
          super(*args, &block) ; return unless main_result
          albums = main_result['album'] or return
          [albums].flatten.compact.each do |album|
            obj_name   = url_encode(album['name']);
            obj_artist = album['artist']['name'] || album['artist']['#text'] rescue nil
            rest = self.class.make_url_query(:artist => obj_artist, :mbid => album['mbid'] )
            req = LastfmAlbumInfoRequest.new("#{obj_name}&#{rest}")
            req.req_generation = req_generation.to_i + 1
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
          super(*args, &block) ; return unless main_result
          tracks = main_result['track'] or return
          [tracks].flatten.compact.each do |track|
            obj_name   = url_encode(track['name']);
            obj_artist = track['artist']['name'] || track['artist']['#text'] rescue nil
            rest = self.class.make_url_query(:artist => obj_artist, :mbid => track['mbid'] )
            req = LastfmTrackInfoRequest.new("#{obj_name}&#{rest}")
            req.req_generation = req_generation.to_i + 1
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
          super(*args, &block) ; return unless main_result
          events = main_result['event'] or return
          [events].flatten.compact.each do |event|
            req = LastfmEventInfoRequest.new(event['id'])
            req.req_generation = req_generation.to_i + 1
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
          super(*args, &block) ; return unless main_result
          users = main_result['user'] or return
          [users].flatten.compact.each do |user|
            req = LastfmUserTopTagsRequest.new(url_encode(user['name']))
            req.req_generation = req_generation.to_i + 1
            yield req
          end
        end
      end
      [ LastfmArtistTopFansRequest, LastfmEventAttendeesRequest, LastfmGroupMembersRequest,
        LastfmTrackTopFansRequest,  LastfmUserFriendsRequest,    LastfmUserNeighboursRequest,
      ].each do |klass|
        klass.class_eval do include LastfmContainsUsers ; end
      end


      #
      # tags               class LastfmAlbumTagsRequest
      # tags               class LastfmArtistTagsRequest
      # tags               class LastfmArtistTopTagsRequest
      # tags               class LastfmTagSimilarRequest
      # tags               class LastfmTagTopTagsRequest
      # tags               class LastfmTrackTagsRequest
      # tags               class LastfmTrackTopTagsRequest
      # tags               class LastfmUserTopTagsRequest
      #
      # artist             class LastfmArtistInfoRequest
      # event              class LastfmEventInfoRequest
      # user               class LastfmUserInfoRequest
      # weeklyalbumchart   class LastfmGroupWeeklyAlbumChartRequest
      # weeklyalbumchart   class LastfmUserWeeklyAlbumChartRequest
      # weeklyartistchart  class LastfmGroupWeeklyArtistChartRequest
      # weeklyartistchart  class LastfmTagWeeklyArtistChartRequest
      # weeklyartistchart  class LastfmUserWeeklyArtistChartRequest
      # weeklychartlist    class LastfmGroupWeeklyChartListRequest
      # weeklychartlist    class LastfmTagWeeklyChartListRequest
      # weeklychartlist    class LastfmUserWeeklyChartListRequest
      # weeklytrackchart   class LastfmGroupWeeklyTrackChartRequest
      # weeklytrackchart   class LastfmUserWeeklyTrackChartRequest
      # #
      # images             class LastfmArtistImagesRequest
      # playlist           class LastfmPlaylistfetchRequest
      # playlists          class LastfmUserPlaylistsRequest
      # podcast            class LastfmArtistPodcastRequest
      # stations           class LastfmUserRecentStationsRequest
      # tasteometer        class LastfmTasteometercompareRequest


    end
  end
end
