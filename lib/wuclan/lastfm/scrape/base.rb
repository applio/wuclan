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
        # API
        cattr_accessor :api_key
        self.api_key = Monkeyshines::CONFIG[:api_key] rescue nil
        #
        def initialize *args
          super *args
          self.identifier = url_encode(identifier)
          self.page = (page.to_i < 1 ? 1 : page.to_i)
          make_url! if (! url)
        end
        #
        # Generate request URL from other attributes
        def make_url
          # This works for most of the twitter calls
          "http://ws.audioscrobbler.com/2.0/?method=#{resource_path}#{identifier}&limit=100&page=#{page}&api_key=#{api_key}&format=json"
        end


        def healthy?
          super && (
            (contents !~ %r{^\{"error":})
            )
        end


        def main_result
          return unless healthy?
          field = resource_path.gsub(/.*\.get(\w+)&.*/, '\1')
          parsed_contents[field] rescue nil
        end

        def result_attrs
          main_result["@attr"] rescue nil
        end

        def num_pages
          attrs = result_attrs
          return 1 if (attrs.blank? || attrs['totalPages'].blank?)
          attrs['totalPages'].to_i.clamp(1,5)
        end

        def recursive_requests &block
          next unless healthy?
          if (num_pages > 2) && (self.page.to_i < 2)
            (2 .. num_pages).each do |page|
              yield self.class.new(identifier, page)
            end
          end
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
      class LastfmUserFriendsRequest            < Base ; self.resource_path = 'user.getfriends&user='             ; end
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

      module LastfmContainsUsers
        def recursive_requests &block
          users = main_result['user'] or return
          users.each do |user|
            yield LastfmUserInfoRequest.new(user['name'])
          end
        end
      end


      class LastfmArtistInfoRequest
        class_inheritable_accessor :requestables
        self.requestables = [
          LastfmArtistShoutsRequest,
          LastfmArtistEventsRequest,
          LastfmArtistTopFansRequest,
          #
          # LastfmArtistImagesRequest,
          # LastfmArtistPodcastRequest,
          # LastfmArtistSimilarRequest,
          # LastfmArtistTagsRequest,
          # LastfmArtistTopAlbumsRequest,
          # LastfmArtistTopTagsRequest,
          # LastfmArtistTopTracksRequest,
        ]
        def recursive_requests &block
          requestables.each do |klass|
            yield klass.new(identifier)
          end
        end
      end

      # album              class LastfmAlbumInfoRequest              < Base ; self.resource_path = 'album.getinfo&album='              ; end
      # albums             class LastfmArtistTopAlbumsRequest        < Base ; self.resource_path = 'artist.gettopalbums&artist='       ; end
      # albums             class LastfmTagTopAlbumsRequest           < Base ; self.resource_path = 'tag.gettopalbums&tag='             ; end
      # albums             class LastfmUserTopAlbumsRequest          < Base ; self.resource_path = 'user.gettopalbums&user='           ; end
      #
      # artist             class LastfmArtistInfoRequest             < Base ; self.resource_path = 'artist.getinfo&artist='            ; end
      # artists            class LastfmArtistSimilarRequest          < Base ; self.resource_path = 'artist.getsimilar&artist='         ; end
      # artists            class LastfmGeoTopArtistsRequest          < Base ; self.resource_path = 'geo.gettopartists&geo='            ; end
      # artists            class LastfmTagTopArtistsRequest          < Base ; self.resource_path = 'tag.gettopartists&tag='            ; end
      # artists            class LastfmUserRecommendedArtistsRequest < Base ; self.resource_path = 'user.getrecommendedartists&user='  ; end
      # artists            class LastfmUserTopArtistsRequest         < Base ; self.resource_path = 'user.gettopartists&user='          ; end
      #
      # event              class LastfmEventInfoRequest              < Base ; self.resource_path = 'event.getinfo&event='              ; end
      # events             class LastfmArtistEventsRequest           < Base ; self.resource_path = 'artist.getevents&artist='          ; end
      # events             class LastfmGeoEventsRequest              < Base ; self.resource_path = 'geo.getevents&geo='                ; end
      # events             class LastfmUserEventsRequest             < Base ; self.resource_path = 'user.getevents&user='              ; end
      # events             class LastfmUserPastEventsRequest         < Base ; self.resource_path = 'user.getpastevents&user='          ; end
      # events             class LastfmUserRecommendedEventsRequest  < Base ; self.resource_path = 'user.getrecommendedevents&user='   ; end
      # events             class LastfmVenueEventsRequest            < Base ; self.resource_path = 'venue.getevents&venue='            ; end
      # events             class LastfmVenuePastEventsRequest        < Base ; self.resource_path = 'venue.getpastevents&venue='        ; end
      #
      # shouts             class LastfmArtistShoutsRequest           < Base ; self.resource_path = 'artist.getshouts&artist='          ; end
      # shouts             class LastfmEventShoutsRequest            < Base ; self.resource_path = 'event.getshouts&event='            ; end
      # shouts             class LastfmUserShoutsRequest             < Base ; self.resource_path = 'user.getshouts&user='              ; end
      #
      # tags               class LastfmAlbumTagsRequest              < Base ; self.resource_path = 'album.gettags&album='              ; end
      # tags               class LastfmArtistTagsRequest             < Base ; self.resource_path = 'artist.gettags&artist='            ; end
      # tags               class LastfmArtistTopTagsRequest          < Base ; self.resource_path = 'artist.gettoptags&artist='         ; end
      # tags               class LastfmTagSimilarRequest             < Base ; self.resource_path = 'tag.getsimilar&tag='               ; end
      # tags               class LastfmTagTopTagsRequest             < Base ; self.resource_path = 'tag.gettoptags&tag='               ; end
      # tags               class LastfmTrackTagsRequest              < Base ; self.resource_path = 'track.gettags&track='              ; end
      # tags               class LastfmTrackTopTagsRequest           < Base ; self.resource_path = 'track.gettoptags&track='           ; end
      # tags               class LastfmUserTopTagsRequest            < Base ; self.resource_path = 'user.gettoptags&user='             ; end
      #
      # track              class LastfmTrackInfoRequest              < Base ; self.resource_path = 'track.getinfo&track='              ; end
      # tracks             class LastfmArtistTopTracksRequest        < Base ; self.resource_path = 'artist.gettoptracks&artist='       ; end
      # tracks             class LastfmGeoTopTracksRequest           < Base ; self.resource_path = 'geo.gettoptracks&geo='             ; end
      # tracks             class LastfmTagTopTracksRequest           < Base ; self.resource_path = 'tag.gettoptracks&tag='             ; end
      # tracks             class LastfmTrackSimilarRequest           < Base ; self.resource_path = 'track.getsimilar&track='           ; end
      # tracks             class LastfmUserLovedTracksRequest        < Base ; self.resource_path = 'user.getlovedtracks&user='         ; end
      # tracks             class LastfmUserRecentTracksRequest       < Base ; self.resource_path = 'user.getrecenttracks&user='        ; end
      # tracks             class LastfmUserTopTracksRequest          < Base ; self.resource_path = 'user.gettoptracks&user='           ; end
      #
      # user               class LastfmUserInfoRequest               < Base ; self.resource_path = 'user.getinfo&user='                ; end
      # users              class LastfmArtistTopFansRequest          < Base ; self.resource_path = 'artist.gettopfans&artist='         ; end
      # users              class LastfmEventAttendeesRequest         < Base ; self.resource_path = 'event.getattendees&event='         ; end
      # users              class LastfmGroupMembersRequest           < Base ; self.resource_path = 'group.getmembers&group='           ; end
      # users              class LastfmTrackTopFansRequest           < Base ; self.resource_path = 'track.gettopfans&track='           ; end
      # users              class LastfmUserFriendsRequest            < Base ; self.resource_path = 'user.getfriends&user='             ; end
      # users              class LastfmUserNeighboursRequest         < Base ; self.resource_path = 'user.getneighbours&user='          ; end
      #
      # weeklyalbumchart   class LastfmGroupWeeklyAlbumChartRequest  < Base ; self.resource_path = 'group.getweeklyalbumchart&group='  ; end
      # weeklyalbumchart   class LastfmUserWeeklyAlbumChartRequest   < Base ; self.resource_path = 'user.getweeklyalbumchart&user='    ; end
      # weeklyartistchart  class LastfmGroupWeeklyArtistChartRequest < Base ; self.resource_path = 'group.getweeklyartistchart&group=' ; end
      # weeklyartistchart  class LastfmTagWeeklyArtistChartRequest   < Base ; self.resource_path = 'tag.getweeklyartistchart&tag='     ; end
      # weeklyartistchart  class LastfmUserWeeklyArtistChartRequest  < Base ; self.resource_path = 'user.getweeklyartistchart&user='   ; end
      # weeklychartlist    class LastfmGroupWeeklyChartListRequest   < Base ; self.resource_path = 'group.getweeklychartlist&group='   ; end
      # weeklychartlist    class LastfmTagWeeklyChartListRequest     < Base ; self.resource_path = 'tag.getweeklychartlist&tag='       ; end
      # weeklychartlist    class LastfmUserWeeklyChartListRequest    < Base ; self.resource_path = 'user.getweeklychartlist&user='     ; end
      # weeklytrackchart   class LastfmGroupWeeklyTrackChartRequest  < Base ; self.resource_path = 'group.getweeklytrackchart&group='  ; end
      # weeklytrackchart   class LastfmUserWeeklyTrackChartRequest   < Base ; self.resource_path = 'user.getweeklytrackchart&user='    ; end
      # #
      # images             class LastfmArtistImagesRequest           < Base ; self.resource_path = 'artist.getimages&artist='          ; end
      # playlist           class LastfmPlaylistfetchRequest          < Base ; self.resource_path = 'playlist.fetch&playlist='          ; end
      # playlists          class LastfmUserPlaylistsRequest          < Base ; self.resource_path = 'user.getplaylists&user='           ; end
      # podcast            class LastfmArtistPodcastRequest          < Base ; self.resource_path = 'artist.getpodcast&artist='         ; end
      # stations           class LastfmUserRecentStationsRequest     < Base ; self.resource_path = 'user.getrecentstations&user='      ; end
      # tasteometer        class LastfmTasteometercompareRequest     < Base ; self.resource_path = 'tasteometer.compare&tasteometer='  ; end


    end
  end
end
