require 'monkeyshines/scrape_request/raw_json_contents'
require 'wuclan/friendster/scrape/base.rb'
module Wuclan
  module Friendster
    module Scrape
      autoload :Base,                         'wuclan/friendster/scrape/base'
      autoload :FriendsterRequestStream,      'wuclan/friendster/scrape/friendster_request_stream'
    end
  end
end
