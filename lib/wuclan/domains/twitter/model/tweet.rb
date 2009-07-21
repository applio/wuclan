module Wuclan::Models

  #
  # Tweet
  #
  # Text and metadata for a twitter status update
  #
  class Tweet < TypedStruct.new(
      [:id,                      Integer     ],
      [:created_at,              Bignum      ],
      [:twitter_user_id,         Integer     ],
      [:favorited,               Integer     ],
      [:truncated,               Integer     ],
      [:in_reply_to_user_id,     Integer     ],
      [:in_reply_to_status_id,   Integer     ],
      [:text,                    String      ],
      [:source,                  String      ],
      [:in_reply_to_screen_name, String      ]
      )
    include ModelCommon

    #
    # Memoized; if you change text you have to flush
    #
    def decoded_text
      @decoded_text ||= text.wukong_decode
    end

    # Key on id
    def num_key_fields()  1  end
    def numeric_id_fields()     [:id, :twitter_user_id, :in_reply_to_status_id, :in_reply_to_user_id] ; end
  end
end
