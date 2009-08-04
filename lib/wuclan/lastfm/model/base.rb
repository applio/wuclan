require 'monkeyshines/scrape_request/raw_json_contents'
module Wuclan
  module Lastfm

    class LastfmUser
    end

    class LastfmShout
    end

    class LastfmArtist
    end

    class LastfmAlbum
    end

    class LastfmTrack
    end

    class LastfmGroup
    end

    class LastfmTag
    end

    class LastfmEvent
    end

    class LastfmVenue
    end

    # Interactions

    class AShoutsB
    end

    # Relationships

    class LastfmTagging < Struct.new(:user_id, :taggable_type, :taggable_id)
    end

    class LastfmListen
    end

    class LastfmAttending
    end

  end
end
