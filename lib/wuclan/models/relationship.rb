module TwitterFriends::StructModel
  # features common to all user-user relationships.
  module RelationshipCommon
  end

  # Follower/Friend relationship
  class AFollowsB           < TypedStruct.new(
      [:user_a_id,              Integer],
      [:user_b_id,              Integer]
      )
    include ModelCommon
    include RelationshipCommon
    # Key on the user-user pair
    def num_key_fields()  2  end
    def numeric_id_fields()     [:user_a_id, :user_b_id] ; end
  end

  # User ==favorites_tweet=> tweet ==by_user=>b
  class AFavoritesB        < TypedStruct.new(
      [:user_a_id,              Integer],
      [:user_b_id,              Integer],
      [:status_id,              Integer]
      )
    include ModelCommon
    include RelationshipCommon
    # Key on user_a-user_b-status_id (really just user_a-status_id is enough)
    def num_key_fields()  3 end
    def numeric_id_fields()     [:user_a_id, :user_b_id, :status_id] ; end
  end

  # Direct (threaded) replies: occur at the start of a tweet.
  class ARepliesB           < TypedStruct.new(
      [:user_a_id,              Integer],
      [:user_b_id,              Integer],
      [:status_id,              Integer],
      [:in_reply_to_status_id,  Integer]
      )
    include ModelCommon
    include RelationshipCommon
    # Key on user_a-user_b-status_id
    def num_key_fields()  3  end
    def numeric_id_fields()     [:user_a_id, :user_b_id, :status_id, :in_reply_to_status_id] ; end
  end

  # Atsign mentions anywhere in the tweet
  # note we have no user_b_id for @foo
  class AAtsignsB           < TypedStruct.new(
      [:user_a_id,              Integer],
      [:user_b_name,            String],
      [:status_id,              Integer]
      )
    include ModelCommon
    include RelationshipCommon
    # Key on user_a-user_b-status_id
    def num_key_fields()  3 end
    def numeric_id_fields()     [:user_a_id, :status_id] ; end
  end

  # Atsign mentions anywhere in the tweet
  # note we have no user_b_id for @foo
  class AAtsignsBId         < TypedStruct.new(
      [:user_a_id,              Integer],
      [:user_b_id,              Integer],
      [:status_id,              Integer]
      )
    include ModelCommon
    include RelationshipCommon
    # Key on user_a-user_b-status_id
    def num_key_fields()  3 end
    def numeric_id_fields()     [:user_a_id, :user_b_id, :status_id] ; end
  end


  #
  # A re-tweet is /sent/ by user_a, repeating an earlier message by user_b
  # Any tweet containing text roughly similar to
  #   RT @user <stuff>
  # with equivalently for RT: retweet, via, retweeting
  #
  #   !!! OR !!!
  #
  # A retweet whore request, something like
  #   pls RT Hey lookit me
  #
  # We just pass along both in the same data structure; the heuristic is poor
  # enough that we leave it to later steps to be clever.  (Note retweets and
  # non-retweet-whore-requests have user_b_name set and unset respectively.)
  #
  # +user_a_id:+   the user who sent the re-tweet
  # +status_id:+   the id of the tweet *containing* the re-tweet (for the ID of the original tweet you're on your own.)
  # +user_b_name:+ the user citied as originating: RT @user_b_name
  # +please_flag:+ a 1 if the text contains 'please' or 'plz' as a stand-alone word
  # +text:+        the *full* text of the tweet
  #
  class ARetweetsB <  TypedStruct.new(
      [:user_a_id,              Integer],
      [:user_b_name,            String],
      [:status_id,              Integer],
      [:please_flag,            Integer],
      [:text,                   String]
      )
    include ModelCommon
    include RelationshipCommon

    def initialize *args
      super *args
      self.please_flag = ModelCommon.unbooleanize(self.please_flag)
    end
    # Key on retweeting_user-user-tweet_id
    def num_key_fields()  3  end
    def numeric_id_fields()     [:user_a_id, :status_id] ; end
    #
    # If there's no user we'll assume this
    # is a retweet and not an rtwhore.
    #
    def is_retweet?
      ! user_b_name.blank?
    end
  end

  class ARetweetsBId <  TypedStruct.new(
      [:user_a_id,              Integer],
      [:user_b_id,              Integer],
      [:status_id,              Integer],
      [:please_flag,            Integer],
      [:text,                   String]
      )
    include ModelCommon
    include RelationshipCommon

    def initialize *args
      super *args
      self.please_flag = ModelCommon.unbooleanize(self.please_flag)
    end

    # Key on retweeting_user-user-tweet_id
    def num_key_fields()  3  end
    def numeric_id_fields()     [:user_a_id, :user_b_id, :status_id] ; end

    #
    # If there's no user we'll assume this
    # is a retweet and not an rtwhore.
    #
    def is_retweet?
      ! user_b_name.blank?
    end
  end



end
