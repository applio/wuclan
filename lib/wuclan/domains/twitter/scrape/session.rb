module Wuclan
  module Domains
    module Twitter
      module Scrape
        #
        # ScrapeSession for the twitter Search API
        #
        # * Manages a series of paginated requests from first result back to last item in
        #   previous scrape session.
        #
        #
        class Session < Struct.new(
            :query_term,
            :priority,
            :prev_rate, :prev_items, :prev_span_min, :prev_span_max
            )
          include Monkeyshines::Paginated
          include Monkeyshines::PaginatedWithLimit

          def initialize *args
            super *args
            self[:query_term].strip!
            [:priority, :prev_items, :prev_span_min, :prev_span_max].each{|attr| self[attr] = self[attr].to_i if self[attr] }
            self[:priority]  = 65536 if (self[:priority] == 0)
            self[:prev_rate] = self[:prev_rate].to_f if self[:prev_rate]
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
            url_str = "http://search.twitter.com/search.json?q=#{query_term}&rpp=#{items_per_page}"
            url_str << "&max_id=#{unscraped_span.max-1}" if unscraped_span.max
            Wuclan::Domains::Twitter::Scrape::TwitterSearchRequest.new url_str
          end

          # def initialize query_term, num_items=nil, min_span=nil, max_span=nil, min_timespan=nil, max_timespan=nil
          #   self.num_items     = num_items.to_i
          #   self.prev_span     = UnionInterval.new(min_span.to_i, max_span.to_i) if min_span || max_span
          #   self.prev_timespan = UnionInterval.new(Time.parse(min_timespan), Time.parse(max_timespan)) rescue nil
          #   super(query_term)
          # end
          #
        end
      end
    end
  end
end
