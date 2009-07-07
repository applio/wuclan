module Wuclan::Models

  #
  #
  #
  module TextElementCommon
    # Key on text-status_id
    def num_key_fields()  2  end
  end

  #
  # Topical #hashtags extracted from tweet text
  #
  # the twitter_user_id is denormalized
  # but is often what we wnat: saves a join
  #
  class Hashtag < TypedStruct.new(
      [:hashtag,         String      ],
      [:status_id,       Integer     ],
      [:twitter_user_id, Integer     ]
      )
    include ModelCommon
    include TextElementCommon
    alias_method :text, :hashtag
    def numeric_id_fields()     [:twitter_user_id, :status_id] ; end
  end

  class TweetUrl < TypedStruct.new(
      [:tweet_url,       String      ],
      [:status_id,       Integer     ],
      [:twitter_user_id, Integer     ]
      )
    include ModelCommon
    include TextElementCommon
    alias_method :text, :tweet_url
    def numeric_id_fields()     [:twitter_user_id, :status_id] ; end
  end
end
