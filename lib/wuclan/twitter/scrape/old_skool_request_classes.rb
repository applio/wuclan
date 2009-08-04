module Wuclan::Twitter::Scrape
  #
  # Older versions of wuclan had a slightly different request naming scheme, and
  # had additional specialized fields. This module adapts old to new; you're only
  # likely to need this if you're me, @mrflip.
  #
  module OldSkoolRequest
    def initialize(priority, twitter_user_id, page, screen_name, url, *args)
      self.twitter_user_id = twitter_user_id
      super(twitter_user_id, page, screen_name, url, *args)
      self.url = make_url
    end

    def parse *args, &block
      handle_special_cases!(*args, &block) or return
      # super *args
      yield self
    end

    def handle_special_cases! *args, &block
      if scraped_at.to_s !~ /\d{14}/
        yield BadRecord.new({:bad_date => scraped_at}.to_json, self.to_flat)
        return nil
      end
      true
    end
  end

  class Followers < TwitterFollowersRequest       ; include OldSkoolRequest ; end
  class Friends   < TwitterFriendsRequest         ; include OldSkoolRequest ; end
  class Favorites < TwitterFavoritesRequest       ; include OldSkoolRequest ; end
  class UserTimeline < TwitterUserTimelineRequest ; include OldSkoolRequest ; end
  class Bogus < BadRecord ;
    def parse suffix=nil, *args
      errors = suffix.split('-')
      klass_name = errors.pop
      yield BadRecord.new("%-23s"%errors.to_json, klass_name, record)
    end
  end
end
