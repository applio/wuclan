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
          "http://ws.audioscrobbler.com/2.0/?method=#{resource_path}&artist=#{identifier}&limit=100&page=#{page}&api_key=#{api_key}&format=json"
        end


        #
        # For parsing, note the different form for empty responses.
        #
      end

      class LastfmAlbumInfoRequest              < Base ; self.resource_path = 'Album.getInfo'              ; end
      class LastfmAlbumTagsRequest              < Base ; self.resource_path = 'Album.getTags'              ; end
      class LastfmArtistEventsRequest           < Base ; self.resource_path = 'Artist.getEvents'           ; end
      class LastfmArtistImagesRequest           < Base ; self.resource_path = 'Artist.getImages'           ; end
      class LastfmArtistInfoRequest             < Base ; self.resource_path = 'Artist.getInfo'             ; end
      class LastfmArtistPodcastRequest          < Base ; self.resource_path = 'Artist.getPodcast'          ; end
      class LastfmArtistShoutsRequest           < Base ; self.resource_path = 'Artist.getShouts'           ; end
      class LastfmArtistShoutsRequest           < Base ; self.resource_path = 'artist.getShouts'           ; end
      class LastfmArtistSimilarRequest          < Base ; self.resource_path = 'Artist.getSimilar'          ; end
      class LastfmArtistTagsRequest             < Base ; self.resource_path = 'Artist.getTags'             ; end
      class LastfmArtistTopAlbumsRequest        < Base ; self.resource_path = 'Artist.getTopAlbums'        ; end
      class LastfmArtistTopFansRequest          < Base ; self.resource_path = 'Artist.getTopFans'          ; end
      class LastfmArtistTopTagsRequest          < Base ; self.resource_path = 'Artist.getTopTags'          ; end
      class LastfmArtistTopTracksRequest        < Base ; self.resource_path = 'Artist.getTopTracks'        ; end
      class LastfmEventAttendeesRequest         < Base ; self.resource_path = 'Event.getAttendees'         ; end
      class LastfmEventInfoRequest              < Base ; self.resource_path = 'Event.getInfo'              ; end
      class LastfmEventShoutsRequest            < Base ; self.resource_path = 'Event.getShouts'            ; end
      class LastfmGeoEventsRequest              < Base ; self.resource_path = 'Geo.getEvents'              ; end
      class LastfmGeoTopArtistsRequest          < Base ; self.resource_path = 'Geo.getTopArtists'          ; end
      class LastfmGeoTopTracksRequest           < Base ; self.resource_path = 'Geo.getTopTracks'           ; end
      class LastfmGroupMembersRequest           < Base ; self.resource_path = 'Group.getMembers'           ; end
      class LastfmGroupWeeklyAlbumChartRequest  < Base ; self.resource_path = 'Group.getWeeklyAlbumChart'  ; end
      class LastfmGroupWeeklyArtistChartRequest < Base ; self.resource_path = 'Group.getWeeklyArtistChart' ; end
      class LastfmGroupWeeklyChartListRequest   < Base ; self.resource_path = 'Group.getWeeklyChartList'   ; end
      class LastfmGroupWeeklyTrackChartRequest  < Base ; self.resource_path = 'Group.getWeeklyTrackChart'  ; end
      class LastfmPlaylistfetchRequest          < Base ; self.resource_path = 'Playlist.fetch'             ; end
      class LastfmTagSimilarRequest             < Base ; self.resource_path = 'Tag.getSimilar'             ; end
      class LastfmTagTopAlbumsRequest           < Base ; self.resource_path = 'Tag.getTopAlbums'           ; end
      class LastfmTagTopArtistsRequest          < Base ; self.resource_path = 'Tag.getTopArtists'          ; end
      class LastfmTagTopTagsRequest             < Base ; self.resource_path = 'Tag.getTopTags'             ; end
      class LastfmTagTopTracksRequest           < Base ; self.resource_path = 'Tag.getTopTracks'           ; end
      class LastfmTagWeeklyArtistChartRequest   < Base ; self.resource_path = 'Tag.getWeeklyArtistChart'   ; end
      class LastfmTagWeeklyChartListRequest     < Base ; self.resource_path = 'Tag.getWeeklyChartList'     ; end
      class LastfmTasteometercompareRequest     < Base ; self.resource_path = 'Tasteometer.compare'        ; end
      class LastfmTrackInfoRequest              < Base ; self.resource_path = 'Track.getInfo'              ; end
      class LastfmTrackSimilarRequest           < Base ; self.resource_path = 'Track.getSimilar'           ; end
      class LastfmTrackTagsRequest              < Base ; self.resource_path = 'Track.getTags'              ; end
      class LastfmTrackTopFansRequest           < Base ; self.resource_path = 'Track.getTopFans'           ; end
      class LastfmTrackTopTagsRequest           < Base ; self.resource_path = 'Track.getTopTags'           ; end
      class LastfmUserEventsRequest             < Base ; self.resource_path = 'User.getEvents'             ; end
      class LastfmUserFriendsRequest            < Base ; self.resource_path = 'User.getFriends'            ; end
      class LastfmUserInfoRequest               < Base ; self.resource_path = 'User.getInfo'               ; end
      class LastfmUserLovedTracksRequest        < Base ; self.resource_path = 'User.getLovedTracks'        ; end
      class LastfmUserNeighboursRequest         < Base ; self.resource_path = 'User.getNeighbours'         ; end
      class LastfmUserPastEventsRequest         < Base ; self.resource_path = 'User.getPastEvents'         ; end
      class LastfmUserPlaylistsRequest          < Base ; self.resource_path = 'User.getPlaylists'          ; end
      class LastfmUserRecentStationsRequest     < Base ; self.resource_path = 'User.getRecentStations'     ; end
      class LastfmUserRecentTracksRequest       < Base ; self.resource_path = 'User.getRecentTracks'       ; end
      class LastfmUserRecommendedArtistsRequest < Base ; self.resource_path = 'User.getRecommendedArtists' ; end
      class LastfmUserRecommendedEventsRequest  < Base ; self.resource_path = 'User.getRecommendedEvents'  ; end
      class LastfmUserShoutsRequest             < Base ; self.resource_path = 'User.getShouts'             ; end
      class LastfmUserTopAlbumsRequest          < Base ; self.resource_path = 'User.getTopAlbums'          ; end
      class LastfmUserTopArtistsRequest         < Base ; self.resource_path = 'User.getTopArtists'         ; end
      class LastfmUserTopTagsRequest            < Base ; self.resource_path = 'User.getTopTags'            ; end
      class LastfmUserTopTracksRequest          < Base ; self.resource_path = 'User.getTopTracks'          ; end
      class LastfmUserWeeklyAlbumChartRequest   < Base ; self.resource_path = 'User.getWeeklyAlbumChart'   ; end
      class LastfmUserWeeklyArtistChartRequest  < Base ; self.resource_path = 'User.getWeeklyArtistChart'  ; end
      class LastfmUserWeeklyChartListRequest    < Base ; self.resource_path = 'User.getWeeklyChartList'    ; end
      class LastfmUserWeeklyTrackChartRequest   < Base ; self.resource_path = 'User.getWeeklyTrackChart'   ; end
      class LastfmVenueEventsRequest            < Base ; self.resource_path = 'Venue.getEvents'            ; end
      class LastfmVenuePastEventsRequest        < Base ; self.resource_path = 'Venue.getPastEvents'        ; end

    end
  end
end

