module Wuclan
  module Twitter
    module Model
      autoload :ModelCommon,        'wuclan/domains/twitter/model/base'
      autoload :TwitterUser,        'wuclan/domains/twitter/model/twitter_user'
      autoload :TwitterUserPartial, 'wuclan/domains/twitter/model/twitter_user'
      autoload :TwitterUserProfile, 'wuclan/domains/twitter/model/twitter_user'
      autoload :TwitterUserStyle,   'wuclan/domains/twitter/model/twitter_user'
      autoload :Tweet,              'wuclan/domains/twitter/model/tweet'
      autoload :AFollowsB,          'wuclan/domains/twitter/model/relationship'
      autoload :AFavoritesB,        'wuclan/domains/twitter/model/relationship'
      autoload :ARepliesB,          'wuclan/domains/twitter/model/relationship'
      autoload :AAtsignsB,          'wuclan/domains/twitter/model/relationship'
      autoload :AAtsignsBId,        'wuclan/domains/twitter/model/relationship'
    end
  end
end
