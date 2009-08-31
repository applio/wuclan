class TwitterSearchJob < Edamame::Job
  #
  # Pagination
  #
  include Monkeyshines::ScrapeRequestCore::Paginating
  include Monkeyshines::ScrapeRequestCore::PaginatedWithLimit
  include Monkeyshines::ScrapeRequestCore::PaginatedWithRate
  # API max pages
  self.hard_request_limit   = 15
  # Items to get each scrape. 1500 is the max, so 1000 gives a safety margin.
  self.target_items_per_job = 1200

  def prev_max()            self.scheduling.prev_max              end
  def prev_max=(val)        self.scheduling.prev_max = val        end
  def prev_items()          self.scheduling.prev_items            end
  def prev_items=(val)      self.scheduling.prev_items = val      end
  def prev_items_rate()     self.scheduling.prev_items_rate       end
  def prev_items_rate=(val) self.scheduling.prev_items_rate = val end
  def delay()               self.scheduling.delay                 end
  def delay=(val)           self.scheduling.delay = val           end

  # creates the paginated request
  def request_for_page page
    req = TwitterSearchRequest.new(obj[:key], page)
    req.url << "&rpp=#{req.max_items}"
    req.url << "&max_id=#{sess_span.min - 1}" if sess_span.min
    req
  end
end

#
# TwitterSearchJob for the twitter Search API
#
# * Manages a series of paginated requests from first result back to last item in
#   previous scrape scrape_job.
#
#
class TwitterSearchRequestStream < Monkeyshines::RequestStream::EdamameQueue
  self.queue_request_timeout = 15 # seconds
  # priority for search jobs if not otherwise given
  QUEUE_PRIORITY = 65536

  def each *args, &block
    work(queue_request_timeout, TwitterSearchJob) do |job|
      # do_faking(qjob)
      job.each_request(&block)
      p ['done work', job.scheduling]
    end
  end
end



#
# # span of previous scrape
# def prev_span
#   @prev_span ||= UnionInterval.new(prev_span_min, prev_max)
# end
# def prev_span= min_max
#   self.prev_span_min, self.prev_max = min_max.to_a
#   @prev_span = UnionInterval.new(prev_span_min, prev_max)
# end
#
# def key
#   query_term
# end
#
#
# def to_hash
#   super().merge( 'type' => self.class.to_s, 'key' => query_term )
# end
#
# #
# #
# # query terms must be URL-encoded
# # (use '+' for space; %23 # %27 ' etc)
# #
# def initialize *args
#   super *args
#   raise "Query term missing" if self.query_term.blank?
#   self[:query_term].strip!
#   [:priority, :prev_items, :prev_span_min, :prev_span_max].each{|attr| self[attr] = self[attr].to_i if self[attr] }
#   self[:prev_rate] = self[:prev_rate].to_f
#   self[:priority]  = DEFAULT_PRIORITY if (self[:priority]  == 0)
#   self[:prev_rate] = nil              if (self[:prev_rate] < 1e-6)
# end
#
# class TwitterSearchStream < Monkeyshines::RequestStream::SimpleRequestStream
#   #
#   # for the given user_id,
#   # gets the user
#   # and then each of the requests in more_request_klasses
#   #
#   def each *args, &block
#     request_store.each do |*raw_job_args|
#       job = klass.new(*raw_job_args)
#       #  do_faking(job)
#       job.each_request(*args, &block)
#     end
#   end
# end
