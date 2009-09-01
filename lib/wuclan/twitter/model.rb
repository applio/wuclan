module Wuclan
  module Twitter
    module Model
      autoload :ModelCommon,        'wuclan/twitter/model/base'
      autoload :TwitterUser,        'wuclan/twitter/model/twitter_user'
      autoload :TwitterUserPartial, 'wuclan/twitter/model/twitter_user'
      autoload :TwitterUserProfile, 'wuclan/twitter/model/twitter_user'
      autoload :TwitterUserStyle,   'wuclan/twitter/model/twitter_user'
      autoload :Tweet,              'wuclan/twitter/model/tweet'
      autoload :AFollowsB,          'wuclan/twitter/model/relationship'
      autoload :AFavoritesB,        'wuclan/twitter/model/relationship'
      autoload :ARepliesB,          'wuclan/twitter/model/relationship'
      autoload :AAtsignsB,          'wuclan/twitter/model/relationship'
      autoload :AAtsignsBId,        'wuclan/twitter/model/relationship'
    end
  end
end
