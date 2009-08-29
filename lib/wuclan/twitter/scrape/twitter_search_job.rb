require 'monkeyshines/scrape_request'
require 'monkeyshines/scrape_request/paginated'
require 'monkeyshines/scrape_request/raw_json_contents'
module Wuclan
  module Twitter
    module Scrape
      #
      # TwitterSearchJob for the twitter Search API
      #
      # * Manages a series of paginated requests from first result back to last item in
      #   previous scrape scrape_job.
      #
      #
      class TwitterSearchJob < Struct.new(
          :query_term,
          :priority,
          :prev_rate, :prev_items, :prev_span_min, :prev_span_max
          )
        # priority for search jobs if not otherwise given
        DEFAULT_PRIORITY = 65536

        #
        # Pagination
        #
        include Monkeyshines::ScrapeJob::Paginated
        include Monkeyshines::ScrapeJob::PaginatedWithLimit

        # API max pages
        self.hard_request_limit = 15
        # API max items per response
        self.items_per_page     = 100

        # creates the paginated request
        def request_for_page page, pageinfo
          req = TwitterSearchRequest.new(query_term, page)
          req.url << "&rpp=#{items_per_page}"
          req.url << "&max_id=#{unscraped_span.max-1}" if unscraped_span.max
          req
        end


        #
        #
        # query terms must be URL-encoded
        # (use '+' for space; %23 # %27 ' etc)
        #
        def initialize *args
          super *args
          raise "Query term missing" if self.query_term.blank?
          self[:query_term].strip!
          [:priority, :prev_items, :prev_span_min, :prev_span_max].each{|attr| self[attr] = self[attr].to_i if self[attr] }
          self[:prev_rate] = self[:prev_rate].to_f
          self[:priority]  = DEFAULT_PRIORITY if (self[:priority]  == 0)
          self[:prev_rate] = nil              if (self[:prev_rate] < 1e-6)
        end

      end
    end
  end
end
