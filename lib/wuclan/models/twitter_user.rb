module Wuclan::Models

  #
  # Mixin: common methods for each of the user representations / partitions
  #
  module TwitterUserCommon
    # #
    # # Datatype info, for exporting strings
    # #
    # MEMBERS_TYPES = {
    #   :created_at,          :date,
    #   :scraped_at,          :date,
    #   :screen_name,         :str,
    #   :protected,           :bool,
    #   :followers_count,     :int,
    #   :friends_count,       :int,
    #   :statuses_count,      :int,
    #   :favourites_count,    :int,
    #   :name,                :str,
    #   :url,                 :str,
    #   :location,            :str,
    #   :description,         :str,
    #   :time_zone,           :str,
    #   :utc_offset,          :int,
    #   # :profile_background_color,       :str,
    #   # :profile_text_color,             :str,
    #   # :profile_link_color,             :str,
    #   # :profile_sidebar_border_color,   :str,
    #   # :profile_sidebar_fill_color,     :str,
    #   # :profile_background_tile,        :bool,
    #   # :profile_background_image_url,   :str,
    #   # :profile_image_url,              :str,
    # }
    # def members_with_types
    #   @members_with_types ||= MEMBERS_TYPES.slice(*members.map(&:to_sym))
    # end

    #
    # Key on id
    #
    # For mutability (preserving different scraped_at observations)
    # needs to be 2 -- id and scraped_at
    #
    def num_key_fields()  1  end
    def numeric_id_fields()     [:id] ; end

    def decoded_name
      @decoded_name        ||= (name        ? name.wukong_decode : '')
    end
    def decoded_location
      @decoded_location    ||= (location    ? location.wukong_decode : '')
    end
    def decoded_description
      @decoded_description ||= (description ? description.wukong_decode : '')
    end
  end

  #
  # Fundamental information on a user.
  #
  class TwitterUser        < TypedStruct.new(
      [:id,                     Integer],
      [:scraped_at,             Bignum],
      [:screen_name,            String],
      [:protected,              Integer],
      [:followers_count,        Integer],
      [:friends_count,          Integer],
      [:statuses_count,         Integer],
      [:favourites_count,       Integer],
      [:created_at,             Bignum]
      )
    include ModelCommon
    include TwitterUserCommon
    alias_method :tweets_count,    :statuses_count
    alias_method :favorites_count, :favourites_count

    #
    # Rate info
    #
    def friends_per_day()      friends_count.to_i   / days_since_created  end
    def followers_per_day()    followers_count.to_i / days_since_created  end
    def favorites_per_day()    favorites_count.to_i / days_since_created  end
    def tweets_per_day()       tweets_count.to_i    / days_since_created  end

  end

  #
  # Outside of a users/show page, when a user is mentioned
  # only this subset of fields appear.
  #
  class TwitterUserPartial < TypedStruct.new(
      [:id,                     Integer],       # appear in TwitterUser
      [:scraped_at,             Bignum],
      [:screen_name,            String],
      [:protected,              Integer],
      [:followers_count,        Integer],
      [:name,                   String],        # appear in TwitterUserProfile
      [:url,                    String],
      [:location,               String],
      [:description,            String],
      [:profile_image_url,      String]         # appear in TwitterUserStyle
      )
    include ModelCommon
    include TwitterUserCommon
  end

  #
  # User-set information about a user
  #
  class TwitterUserProfile < TypedStruct.new(
      [:id,                     Integer],
      [:scraped_at,             Bignum],
      [:name,                   String],
      [:url,                    String],
      [:location,               String],
      [:description,            String],
      [:time_zone,              String],
      [:utc_offset,             String]
      )
    include ModelCommon
    include TwitterUserCommon
  end

  #
  # How the user has styled their page
  #
  class TwitterUserStyle   < TypedStruct.new(
      [:id,                             Integer],
      [:scraped_at,                     Bignum],
      [:profile_background_color,       String],
      [:profile_text_color,             String],
      [:profile_link_color,             String],
      [:profile_sidebar_border_color,   String],
      [:profile_sidebar_fill_color,     String],
      [:profile_background_tile,        String],
      [:profile_background_image_url,   String],
      [:profile_image_url,              String]
      )
    include ModelCommon
    include TwitterUserCommon
  end

  #
  # For passing around just screen_name => id mapping
  #
  class TwitterUserId      < TypedStruct.new(
      [:id,                     Integer],
      [:screen_name,            String],
      [:full,                   Integer],
      [:followers_count,        Integer],
      [:created_at,             Bignum],
      [:protected,              Integer],
      [:status,                 String]
      )
    include ModelCommon
    include TwitterUserCommon
    def num_key_fields()  1  end
    # def initialize id=nil, *args
    #   super id, *args
    #   self.id = "%010d" % id.to_i if id
    # end
  end
end
