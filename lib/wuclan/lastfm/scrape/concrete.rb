module Wuclan
  module Lastfm
    module Scrape

      #
      # Defines the concrete terms of the API
      #

      class LastfmAlbumInfoRequest              < Base ; self.api_method = 'album.getinfo&album='              ; end
      class LastfmAlbumTagsRequest              < Base ; self.api_method = 'album.gettags&album='              ; end
      class LastfmArtistEventsRequest           < Base ; self.api_method = 'artist.getevents&artist='          ; end
      class LastfmArtistImagesRequest           < Base ; self.api_method = 'artist.getimages&artist='          ; end
      class LastfmArtistInfoRequest             < Base ; self.api_method = 'artist.getinfo&artist='            ; end
      class LastfmArtistPodcastRequest          < Base ; self.api_method = 'artist.getpodcast&artist='         ; end
      class LastfmArtistShoutsRequest           < Base ; self.api_method = 'artist.getshouts&artist='          ; end
      class LastfmArtistSimilarRequest          < Base ; self.api_method = 'artist.getsimilar&artist='         ; end
      class LastfmArtistTagsRequest             < Base ; self.api_method = 'artist.gettags&artist='            ; end
      class LastfmArtistTopAlbumsRequest        < Base ; self.api_method = 'artist.gettopalbums&artist='       ; end
      class LastfmArtistTopFansRequest          < Base ; self.api_method = 'artist.gettopfans&artist='         ; end
      class LastfmArtistTopTagsRequest          < Base ; self.api_method = 'artist.gettoptags&artist='         ; end
      class LastfmArtistTopTracksRequest        < Base ; self.api_method = 'artist.gettoptracks&artist='       ; end
      class LastfmEventAttendeesRequest         < Base ; self.api_method = 'event.getattendees&event='         ; end
      class LastfmEventInfoRequest              < Base ; self.api_method = 'event.getinfo&event='              ; end
      class LastfmEventShoutsRequest            < Base ; self.api_method = 'event.getshouts&event='            ; end
      class LastfmGeoEventsRequest              < Base ; self.api_method = 'geo.getevents&geo='                ; end
      class LastfmGeoTopArtistsRequest          < Base ; self.api_method = 'geo.gettopartists&geo='            ; end
      class LastfmGeoTopTracksRequest           < Base ; self.api_method = 'geo.gettoptracks&geo='             ; end
      class LastfmGroupMembersRequest           < Base ; self.api_method = 'group.getmembers&group='           ; end
      class LastfmGroupWeeklyAlbumChartRequest  < Base ; self.api_method = 'group.getweeklyalbumchart&group='  ; end
      class LastfmGroupWeeklyArtistChartRequest < Base ; self.api_method = 'group.getweeklyartistchart&group=' ; end
      class LastfmGroupWeeklyChartListRequest   < Base ; self.api_method = 'group.getweeklychartlist&group='   ; end
      class LastfmGroupWeeklyTrackChartRequest  < Base ; self.api_method = 'group.getweeklytrackchart&group='  ; end
      class LastfmPlaylistfetchRequest          < Base ; self.api_method = 'playlist.fetch&playlist='          ; end
      class LastfmTagSimilarRequest             < Base ; self.api_method = 'tag.getsimilar&tag='               ; end
      class LastfmTagTopAlbumsRequest           < Base ; self.api_method = 'tag.gettopalbums&tag='             ; end
      class LastfmTagTopArtistsRequest          < Base ; self.api_method = 'tag.gettopartists&tag='            ; end
      class LastfmTagTopTagsRequest             < Base ; self.api_method = 'tag.gettoptags&tag='               ; end
      class LastfmTagTopTracksRequest           < Base ; self.api_method = 'tag.gettoptracks&tag='             ; end
      class LastfmTagWeeklyArtistChartRequest   < Base ; self.api_method = 'tag.getweeklyartistchart&tag='     ; end
      class LastfmTagWeeklyChartListRequest     < Base ; self.api_method = 'tag.getweeklychartlist&tag='       ; end
      class LastfmTasteometercompareRequest     < Base ; self.api_method = 'tasteometer.compare&tasteometer='  ; end
      class LastfmTrackInfoRequest              < Base ; self.api_method = 'track.getinfo&track='              ; end
      class LastfmTrackSimilarRequest           < Base ; self.api_method = 'track.getsimilar&track='           ; end
      class LastfmTrackTagsRequest              < Base ; self.api_method = 'track.gettags&track='              ; end
      class LastfmTrackTopFansRequest           < Base ; self.api_method = 'track.gettopfans&track='           ; end
      class LastfmTrackTopTagsRequest           < Base ; self.api_method = 'track.gettoptags&track='           ; end
      class LastfmUserEventsRequest             < Base ; self.api_method = 'user.getevents&user='              ; end
      class LastfmUserFriendsRequest            < Base ; self.api_method = 'user.getfriends&recenttracks=1&user='             ; end
      class LastfmUserInfoRequest               < Base ; self.api_method = 'user.getinfo&user='                ; end
      class LastfmUserLovedTracksRequest        < Base ; self.api_method = 'user.getlovedtracks&user='         ; end
      class LastfmUserNeighboursRequest         < Base ; self.api_method = 'user.getneighbours&user='          ; end
      class LastfmUserPastEventsRequest         < Base ; self.api_method = 'user.getpastevents&user='          ; end
      class LastfmUserPlaylistsRequest          < Base ; self.api_method = 'user.getplaylists&user='           ; end
      class LastfmUserRecentStationsRequest     < Base ; self.api_method = 'user.getrecentstations&user='      ; end
      class LastfmUserRecentTracksRequest       < Base ; self.api_method = 'user.getrecenttracks&user='        ; end
      class LastfmUserRecommendedArtistsRequest < Base ; self.api_method = 'user.getrecommendedartists&user='  ; end
      class LastfmUserRecommendedEventsRequest  < Base ; self.api_method = 'user.getrecommendedevents&user='   ; end
      class LastfmUserShoutsRequest             < Base ; self.api_method = 'user.getshouts&user='              ; end
      class LastfmUserTopAlbumsRequest          < Base ; self.api_method = 'user.gettopalbums&user='           ; end
      class LastfmUserTopArtistsRequest         < Base ; self.api_method = 'user.gettopartists&user='          ; end
      class LastfmUserTopTagsRequest            < Base ; self.api_method = 'user.gettoptags&user='             ; end
      class LastfmUserTopTracksRequest          < Base ; self.api_method = 'user.gettoptracks&user='           ; end
      class LastfmUserWeeklyAlbumChartRequest   < Base ; self.api_method = 'user.getweeklyalbumchart&user='    ; end
      class LastfmUserWeeklyArtistChartRequest  < Base ; self.api_method = 'user.getweeklyartistchart&user='   ; end
      class LastfmUserWeeklyChartListRequest    < Base ; self.api_method = 'user.getweeklychartlist&user='     ; end
      class LastfmUserWeeklyTrackChartRequest   < Base ; self.api_method = 'user.getweeklytrackchart&user='    ; end
      class LastfmVenueEventsRequest            < Base ; self.api_method = 'venue.getevents&venue='            ; end
      class LastfmVenuePastEventsRequest        < Base ; self.api_method = 'venue.getpastevents&venue='        ; end

      # Singular
      class LastfmAlbumInfoRequest              < Base ; self.main_fieldname = 'album'                 ; self.response_type = 'album'             ; end
      class LastfmArtistInfoRequest             < Base ; self.main_fieldname = 'artist'                ; self.response_type = 'artist'            ; end
      class LastfmEventInfoRequest              < Base ; self.main_fieldname = 'event'                 ; self.response_type = 'event'             ; end
      class LastfmTrackInfoRequest              < Base ; self.main_fieldname = 'track'                 ; self.response_type = 'track'             ; end
      class LastfmUserInfoRequest               < Base ; self.main_fieldname = 'user'                  ; self.response_type = 'user'              ; end
      # Albums
      class LastfmArtistTopAlbumsRequest        < Base ; self.main_fieldname = 'topalbums'             ; self.response_type = 'album'             ; end
      class LastfmTagTopAlbumsRequest           < Base ; self.main_fieldname = 'topalbums'             ; self.response_type = 'album'             ; end
      class LastfmUserTopAlbumsRequest          < Base ; self.main_fieldname = 'topalbums'             ; self.response_type = 'album'             ; end
      # Tracks
      class LastfmArtistTopTracksRequest        < Base ; self.main_fieldname = 'toptracks'             ; self.response_type = 'track'             ; end
      class LastfmGeoTopTracksRequest           < Base ; self.main_fieldname = 'toptracks'             ; self.response_type = 'track'             ; end
      class LastfmTagTopTracksRequest           < Base ; self.main_fieldname = 'toptracks'             ; self.response_type = 'track'             ; end
      class LastfmUserTopTracksRequest          < Base ; self.main_fieldname = 'toptracks'             ; self.response_type = 'track'             ; end
      class LastfmUserLovedTracksRequest        < Base ; self.main_fieldname = 'lovedtracks'           ; self.response_type = 'track'             ; end
      class LastfmUserRecentTracksRequest       < Base ; self.main_fieldname = 'recenttracks'          ; self.response_type = 'track'             ; end
      class LastfmTrackSimilarRequest           < Base ; self.main_fieldname = 'similartracks'         ; self.response_type = 'track'             ; end
      # Artists
      class LastfmArtistSimilarRequest          < Base ; self.main_fieldname = 'artists'               ; self.response_type = 'artist'            ; end
      class LastfmUserRecommendedArtistsRequest < Base ; self.main_fieldname = 'recommendedartists'    ; self.response_type = 'artist'            ; end
      class LastfmGeoTopArtistsRequest          < Base ; self.main_fieldname = 'topartists'            ; self.response_type = 'artist'            ; end
      class LastfmTagTopArtistsRequest          < Base ; self.main_fieldname = 'topartists'            ; self.response_type = 'artist'            ; end
      class LastfmUserTopArtistsRequest         < Base ; self.main_fieldname = 'topartists'            ; self.response_type = 'artist'            ; end
      # Events
      class LastfmArtistEventsRequest           < Base ; self.main_fieldname = 'events'                ; self.response_type = 'event'             ; end
      class LastfmGeoEventsRequest              < Base ; self.main_fieldname = 'events'                ; self.response_type = 'event'             ; end
      class LastfmUserEventsRequest             < Base ; self.main_fieldname = 'events'                ; self.response_type = 'event'             ; end
      class LastfmVenueEventsRequest            < Base ; self.main_fieldname = 'events'                ; self.response_type = 'event'             ; end
      class LastfmUserPastEventsRequest         < Base ; self.main_fieldname = 'pastevents'            ; self.response_type = 'event'             ; end
      class LastfmVenuePastEventsRequest        < Base ; self.main_fieldname = 'pastevents'            ; self.response_type = 'event'             ; end
      class LastfmUserRecommendedEventsRequest  < Base ; self.main_fieldname = 'recommendedevents'     ; self.response_type = 'event'             ; end
      # Users
      class LastfmEventAttendeesRequest         < Base ; self.main_fieldname = 'attendees'             ; self.response_type = 'user'              ; end
      class LastfmUserFriendsRequest            < Base ; self.main_fieldname = 'friends'               ; self.response_type = 'user'              ; end
      class LastfmArtistTopFansRequest          < Base ; self.main_fieldname = 'topfans'               ; self.response_type = 'user'              ; end
      class LastfmTrackTopFansRequest           < Base ; self.main_fieldname = 'topfans'               ; self.response_type = 'user'              ; end
      class LastfmGroupMembersRequest           < Base ; self.main_fieldname = 'members'               ; self.response_type = 'user'              ; end
      class LastfmUserNeighboursRequest         < Base ; self.main_fieldname = 'neighbours'            ; self.response_type = 'user'              ; end
      # Shouts
      class LastfmArtistShoutsRequest           < Base ; self.main_fieldname = 'shouts'                ; self.response_type = 'shout'             ; end
      class LastfmEventShoutsRequest            < Base ; self.main_fieldname = 'shouts'                ; self.response_type = 'shout'             ; end
      class LastfmUserShoutsRequest             < Base ; self.main_fieldname = 'shouts'                ; self.response_type = 'shout'             ; end
      # Tags
      class LastfmArtistTagsRequest             < Base ; self.main_fieldname = 'similartags'           ; self.response_type = 'tag'               ; end
      class LastfmTagSimilarRequest             < Base ; self.main_fieldname = 'similartags'           ; self.response_type = 'tag'               ; end
      class LastfmAlbumTagsRequest              < Base ; self.main_fieldname = 'tags'                  ; self.response_type = 'tag'               ; end
      class LastfmTrackTagsRequest              < Base ; self.main_fieldname = 'tags'                  ; self.response_type = 'tag'               ; end
      class LastfmArtistTopTagsRequest          < Base ; self.main_fieldname = 'toptags'               ; self.response_type = 'tag'               ; end
      class LastfmTagTopTagsRequest             < Base ; self.main_fieldname = 'toptags'               ; self.response_type = 'tag'               ; end
      class LastfmTrackTopTagsRequest           < Base ; self.main_fieldname = 'toptags'               ; self.response_type = 'tag'               ; end
      class LastfmUserTopTagsRequest            < Base ; self.main_fieldname = 'toptags'               ; self.response_type = 'tag'               ; end
      # Charts
      class LastfmGroupWeeklyAlbumChartRequest  < Base ; self.main_fieldname = 'weeklyalbumchart'      ; self.response_type = 'weeklyalbumchart'  ; end
      class LastfmUserWeeklyAlbumChartRequest   < Base ; self.main_fieldname = 'weeklyalbumchart'      ; self.response_type = 'weeklyalbumchart'  ; end
      class LastfmGroupWeeklyArtistChartRequest < Base ; self.main_fieldname = 'weeklyartistchart'     ; self.response_type = 'weeklyartistchart' ; end
      class LastfmTagWeeklyArtistChartRequest   < Base ; self.main_fieldname = 'weeklyartistchart'     ; self.response_type = 'weeklyartistchart' ; end
      class LastfmUserWeeklyArtistChartRequest  < Base ; self.main_fieldname = 'weeklyartistchart'     ; self.response_type = 'weeklyartistchart' ; end
      class LastfmGroupWeeklyChartListRequest   < Base ; self.main_fieldname = 'weeklychartlist'       ; self.response_type = 'weeklychartlist'   ; end
      class LastfmTagWeeklyChartListRequest     < Base ; self.main_fieldname = 'weeklychartlist'       ; self.response_type = 'weeklychartlist'   ; end
      class LastfmUserWeeklyChartListRequest    < Base ; self.main_fieldname = 'weeklychartlist'       ; self.response_type = 'weeklychartlist'   ; end
      class LastfmGroupWeeklyTrackChartRequest  < Base ; self.main_fieldname = 'weeklytrackchart'      ; self.response_type = 'weeklytrackchart'  ; end
      class LastfmUserWeeklyTrackChartRequest   < Base ; self.main_fieldname = 'weeklytrackchart'      ; self.response_type = 'weeklytrackchart'  ; end

      # class LastfmArtistImagesRequest           < Base ; self.main_fieldname = 'images'                ; end
      # class LastfmUserPlaylistsRequest          < Base ; self.main_fieldname = 'playlists'             ; end
      # class LastfmArtistPodcastRequest          < Base ; self.main_fieldname = 'podcast'               ; end
      # class LastfmUserRecentStationsRequest     < Base ; self.main_fieldname = 'recentstations'        ; end
      # class LastfmPlaylistfetchRequest          < Base ; self.main_fieldname ='''                ; end
      # class LastfmTasteometercompareRequest     < Base ; self.main_fieldname =''         ; end


    end
  end
end
































































