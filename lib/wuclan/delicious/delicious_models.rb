module Wuclan
  module Models

    #
    # Models for the delicious.com (formerly del.icio.us) social network
    #
    # Link:         has tags,   tagged by socialites
    # Socialite:                describes links with tabs,  uses tags,         follows/followedby socialites
    # Tag:          tags links,                             used by socialites

    class DeliciousLink < Struct.new(
        :delicious_link_id, :url, :title, :taggers_count)
    end
    class DeliciousTag < Struct.new(
        :name )
    end
    class DeliciousUser < Struct.new(
        :id, :scraped_at, :screen_name, :protected, :followers_count, :friends_count, :taggings_count, :name, :description, :bio_url )
    end

    class DeliciousTagging < Struct.new(
        :tag_name, :delicious_link_id, :screen_name, :created_at, :text, :description)
    end

  end
end
