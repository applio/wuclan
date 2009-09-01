require 'wuclan/lastfm/scrape/recursive_requests'

module Wuclan
  module Lastfm
    module Scrape

      Base.class_eval do
        #
        # Pagination
        #
        include Monkeyshines::ScrapeRequestCore::Paginating
        include Monkeyshines::ScrapeRequestCore::PaginatedWithLimit
        # include Monkeyshines::ScrapeRequestCore::PaginatedWithRate

        # Items to get each re-visit. If there are up to 50 items per page,
        # target_items_per_job of 1000 will try to reschedule so that its return visit
        # makes about twenty page requests.
        self.target_items_per_job = 150

        # creates the paginated request
        def request_for_page page
          req = TwitterSearchRequest.new(obj[:key], page)
          req.url << "&rpp=#{req.max_items}"
          req.url << "&max_id=#{sess_span.min - 1}" if sess_span.min
          req
        end
      end

    end
  end
end
