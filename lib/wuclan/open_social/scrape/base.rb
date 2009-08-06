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

      class AlbumInfoRequest              < Base ; self.resource_path = 'Album.getInfo'              ; end
      class AlbumTagsRequest              < Base ; self.resource_path = 'Album.getTags'              ; end
      class ArtistEventsRequest           < Base ; self.resource_path = 'Artist.getEvents'           ; end
      class ArtistImagesRequest           < Base ; self.resource_path = 'Artist.getImages'           ; end
      class ArtistInfoRequest             < Base ; self.resource_path = 'Artist.getInfo'             ; end
      class ArtistPodcastRequest          < Base ; self.resource_path = 'Artist.getPodcast'          ; end
      class ArtistShoutsRequest           < Base ; self.resource_path = 'Artist.getShouts'           ; end
      class ArtistShoutsRequest           < Base ; self.resource_path = 'artist.getShouts'           ; end
      class ArtistSimilarRequest          < Base ; self.resource_path = 'Artist.getSimilar'          ; end
      class ArtistTagsRequest             < Base ; self.resource_path = 'Artist.getTags'             ; end
      class ArtistTopAlbumsRequest        < Base ; self.resource_path = 'Artist.getTopAlbums'        ; end
      class ArtistTopFansRequest          < Base ; self.resource_path = 'Artist.getTopFans'          ; end
      class ArtistTopTagsRequest          < Base ; self.resource_path = 'Artist.getTopTags'          ; end
      class ArtistTopTracksRequest        < Base ; self.resource_path = 'Artist.getTopTracks'        ; end
      class EventAttendeesRequest         < Base ; self.resource_path = 'Event.getAttendees'         ; end
      class EventInfoRequest              < Base ; self.resource_path = 'Event.getInfo'              ; end
      class EventShoutsRequest            < Base ; self.resource_path = 'Event.getShouts'            ; end
      class GeoEventsRequest              < Base ; self.resource_path = 'Geo.getEvents'              ; end
      class GeoTopArtistsRequest          < Base ; self.resource_path = 'Geo.getTopArtists'          ; end
      class GeoTopTracksRequest           < Base ; self.resource_path = 'Geo.getTopTracks'           ; end
      class GroupMembersRequest           < Base ; self.resource_path = 'Group.getMembers'           ; end
      class GroupWeeklyAlbumChartRequest  < Base ; self.resource_path = 'Group.getWeeklyAlbumChart'  ; end
      class GroupWeeklyArtistChartRequest < Base ; self.resource_path = 'Group.getWeeklyArtistChart' ; end
      class GroupWeeklyChartListRequest   < Base ; self.resource_path = 'Group.getWeeklyChartList'   ; end
      class GroupWeeklyTrackChartRequest  < Base ; self.resource_path = 'Group.getWeeklyTrackChart'  ; end
      class PlaylistfetchRequest          < Base ; self.resource_path = 'Playlist.fetch'             ; end
      class TagSimilarRequest             < Base ; self.resource_path = 'Tag.getSimilar'             ; end
      class TagTopAlbumsRequest           < Base ; self.resource_path = 'Tag.getTopAlbums'           ; end
      class TagTopArtistsRequest          < Base ; self.resource_path = 'Tag.getTopArtists'          ; end
      class TagTopTagsRequest             < Base ; self.resource_path = 'Tag.getTopTags'             ; end
      class TagTopTracksRequest           < Base ; self.resource_path = 'Tag.getTopTracks'           ; end
      class TagWeeklyArtistChartRequest   < Base ; self.resource_path = 'Tag.getWeeklyArtistChart'   ; end
      class TagWeeklyChartListRequest     < Base ; self.resource_path = 'Tag.getWeeklyChartList'     ; end
      class TasteometercompareRequest     < Base ; self.resource_path = 'Tasteometer.compare'        ; end
      class TrackInfoRequest              < Base ; self.resource_path = 'Track.getInfo'              ; end
      class TrackSimilarRequest           < Base ; self.resource_path = 'Track.getSimilar'           ; end
      class TrackTagsRequest              < Base ; self.resource_path = 'Track.getTags'              ; end
      class TrackTopFansRequest           < Base ; self.resource_path = 'Track.getTopFans'           ; end
      class TrackTopTagsRequest           < Base ; self.resource_path = 'Track.getTopTags'           ; end
      class UserEventsRequest             < Base ; self.resource_path = 'User.getEvents'             ; end
      class UserFriendsRequest            < Base ; self.resource_path = 'User.getFriends'            ; end
      class UserInfoRequest               < Base ; self.resource_path = 'User.getInfo'               ; end
      class UserLovedTracksRequest        < Base ; self.resource_path = 'User.getLovedTracks'        ; end
      class UserNeighboursRequest         < Base ; self.resource_path = 'User.getNeighbours'         ; end
      class UserPastEventsRequest         < Base ; self.resource_path = 'User.getPastEvents'         ; end
      class UserPlaylistsRequest          < Base ; self.resource_path = 'User.getPlaylists'          ; end
      class UserRecentStationsRequest     < Base ; self.resource_path = 'User.getRecentStations'     ; end
      class UserRecentTracksRequest       < Base ; self.resource_path = 'User.getRecentTracks'       ; end
      class UserRecommendedArtistsRequest < Base ; self.resource_path = 'User.getRecommendedArtists' ; end
      class UserRecommendedEventsRequest  < Base ; self.resource_path = 'User.getRecommendedEvents'  ; end
      class UserShoutsRequest             < Base ; self.resource_path = 'User.getShouts'             ; end
      class UserTopAlbumsRequest          < Base ; self.resource_path = 'User.getTopAlbums'          ; end
      class UserTopArtistsRequest         < Base ; self.resource_path = 'User.getTopArtists'         ; end
      class UserTopTagsRequest            < Base ; self.resource_path = 'User.getTopTags'            ; end
      class UserTopTracksRequest          < Base ; self.resource_path = 'User.getTopTracks'          ; end
      class UserWeeklyAlbumChartRequest   < Base ; self.resource_path = 'User.getWeeklyAlbumChart'   ; end
      class UserWeeklyArtistChartRequest  < Base ; self.resource_path = 'User.getWeeklyArtistChart'  ; end
      class UserWeeklyChartListRequest    < Base ; self.resource_path = 'User.getWeeklyChartList'    ; end
      class UserWeeklyTrackChartRequest   < Base ; self.resource_path = 'User.getWeeklyTrackChart'   ; end
      class VenueEventsRequest            < Base ; self.resource_path = 'Venue.getEvents'            ; end
      class VenuePastEventsRequest        < Base ; self.resource_path = 'Venue.getPastEvents'        ; end

    end
  end
end

