module Wuclan
  module Domains
    module Twitter
      module Scrape

        class TimelineRequest
          #
          # unpacks the raw API response, yielding all the interesting objects
          # and relationships within.
          #
          def parse &block
            return unless healthy?
            parsed_contents.each do |hsh|
              json_obj = JsonTweetWithUser.new(hsh, 'scraped_at' => scraped_at)
              next unless json_obj && json_obj.healthy?
              # Extract user, tweet and relationship
              json_obj.each(&block)
            end
          end
        end


        #
        # API request for a user's status timeline.
        # Maximum 16 pages, 200 a pop.
        #
        # Produces up to 200 Tweets.
        #
        # http://apiwiki.twitter.com/Twitter-REST-API-Method%3A-statuses-user_timeline
        #
        class UserTimelineRequest  < Wuclan::Domains::Twitter::Scrape::TimelineRequest
          self.resource_path  = 'statuses/user_timeline'
          self.page_limit     = 16
          self.items_per_page = 200
          def items_count(thing) thing.status_count end
          def url() "http://twitter.com/#{resource_path}/#{identifier}.json?page=#{page}&count=#{items_per_page}"  end
        end

        #
        #
        # Not available any more after May 2009 -- use Hosebird
        #
        class PublicTimelineRequest < Wuclan::Domains::Twitter::Scrape::TimelineRequest
          self.resource_path  = 'statuses/public_timeline'
          self.page_limit     = 1
          self.items_per_page = 600
          def items_count(thing) 1 end
          def url() "http://twitter.com/#{resource_path}.json"  end
        end

        # class HosebirdRequest     < Wuclan::Domains::Twitter::Scrape::Base
        #   #self.resource_path = 'statuses/public_timeline'
        # end
      end

    end
  end
end
