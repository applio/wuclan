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
        include Monkeyshines::Paginated
        include Monkeyshines::PaginatedWithLimit

        def initialize *args
          super *args
          raise "Query term missing" if self.query_term.blank?
          self[:query_term].strip!
          [:priority, :prev_items, :prev_span_min, :prev_span_max].each{|attr| self[attr] = self[attr].to_i if self[attr] }
          self[:prev_rate] = self[:prev_rate].to_f
          self[:priority]  = 65536 if (self[:priority]  == 0)
          self[:prev_rate] = nil   if (self[:prev_rate] < 1e-6)
        end
        #
        # Define API features
        #
        self.items_per_page     = 100
        self.hard_request_limit = 15
        #
        # Generate paginated TwitterSearchScrapeRequest
        #
        def make_request page, pageinfo
          url_str = base_url
          url_str << "&rpp=#{items_per_page}"
          url_str << "&max_id=#{unscraped_span.max-1}" if unscraped_span.max
          Wuclan::Twitter::Scrape::TwitterSearchRequest.new url_str
        end

        #
        # Durable handle for this resource, independent of the page/max_id/whatever
        #
        def base_url
          "http://search.twitter.com/search.json?q=#{query_term}"
        end
      end
    end
  end
end
