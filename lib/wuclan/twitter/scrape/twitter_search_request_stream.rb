#
# TwitterSearchJob for the twitter Search API
#
# * Manages a series of paginated requests from first result back to last item in
#   previous scrape scrape_job.
#
#
class TwitterSearchRequestStream < Monkeyshines::RequestStream::EdamameQueue
  QUEUE_REQUEST_TIMEOUT = 2 # seconds
  # priority for search jobs if not otherwise given
  QUEUE_PRIORITY = 65536

  #
  # Pagination
  #
  include Monkeyshines::ScrapeRequestCore::Paginating
  include Monkeyshines::ScrapeRequestCore::PaginatedWithLimit
  # API max pages
  self.hard_request_limit = 15

  # creates the paginated request
  def request_for_page qjob, page
    # p [qjob, page, qjob.obj, qjob.scheduling]
    req = TwitterSearchRequest.new(qjob.obj[:key], page)
    req.url << "&rpp=#{req.max_items}"
    req.url << "&max_id=#{sess_span.min - 1}" if sess_span.min
    req
  end

  def each *args, &block
    work(QUEUE_REQUEST_TIMEOUT) do |qjob|
      # do_faking(qjob)
      each_request(qjob, &block)
    end
  end
end

Beanstalk::Job.class_eval do
  def prev_max()     scheduling.prev_max       end
  def prev_max=(val) scheduling.prev_max = val end
end

# I, [2009-08-31T06:11:43.327757 #44551]  INFO -- : Opening HTTP connection for search.twitter.com at Mon Aug 31 06:11:43 -0500 2009
# I, [2009-08-31T06:11:44.118253 #44551]  INFO -- : Opening file /Users/flip/ics/wuclan/examples/twitter/scrape_twitter_search/work/test_output.tsv with mode w
# I, [2009-08-31T06:11:44.120417 #44551]  INFO -- :          1        0.0 13315.3 200     http://search.twitter.com/search.json?q=twitter&rpp=100 {"results":[{"text":"RT - GET 300 twitter followers in a day - NO MONEY NEEDED -
# I, [2009-08-31T06:11:46.119617 #44551]  INFO -- :          2        2.0     1.0 200     http://search.twitter.com/search.json?q=twitter&rpp=100&max_id=3663627354       {"results":[{"text":"M\u00fcssen Landtagswahlen wiederholt werden?: Twitter-Nutze
# I, [2009-08-31T06:11:48.121428 #44551]  INFO -- :          3        4.0     0.7 200     http://search.twitter.com/search.json?q=twitter&rpp=100&max_id=3663617624       {"results":[{"text":"Just added myself to the http:\/\/wefollow.com twitter direc
# I, [2009-08-31T06:11:49.922758 #44551]  INFO -- :          4        5.8     0.7 200     http://search.twitter.com/search.json?q=twitter&rpp=100&max_id=3663609731       {"results":[{"text":"RT @SorrindopraVida: Bom dia! Hj o #ETO vai meditar a Palavr
# I, [2009-08-31T06:11:52.147084 #44551]  INFO -- :          5        8.0     0.6 200     http://search.twitter.com/search.json?q=http&rpp=100    {"results":[{"text":"The competition with @LachlanCrompton to create a Swab Villa
# I, [2009-08-31T06:11:53.925386 #44551]  INFO -- :          6        9.8     0.6 200     http://search.twitter.com/search.json?q=http&rpp=100&max_id=3663635207  {"results":[{"text":"Quieres comer pescadito? pues vente a la Costa del Sol \nHot
# [(job server=localhost:11240 id=378 size=243), 1, {:type=>"TwitterSearchRequest", :key=>"twitter"}, #<Edamame::Scheduling::Recurring:0x17e3050 @period=20.0748601464227, @prev_max=3290689919>]
# [(job server=localhost:11240 id=378 size=243), 2, {:type=>"TwitterSearchRequest", :key=>"twitter"}, #<Edamame::Scheduling::Recurring:0x17e3050 @period=20.0748601464227, @prev_max=3290689919>]
# [(job server=localhost:11240 id=378 size=243), 3, {:type=>"TwitterSearchRequest", :key=>"twitter"}, #<Edamame::Scheduling::Recurring:0x17e3050 @period=20.0748601464227, @prev_max=3290689919>]
# [(job server=localhost:11240 id=378 size=243), 4, {:type=>"TwitterSearchRequest", :key=>"twitter"}, #<Edamame::Scheduling::Recurring:0x17e3050 @period=20.0748601464227, @prev_max=3290689919>]
# [(job server=localhost:11240 id=379 size=241), 1, {:type=>"TwitterSearchRequest", :key=>"http"   }, #<Edamame::Scheduling::Recurring:0x176d094 @period=0.535726847370112, @prev_max=3290738573>]
# [(job server=localhost:11240 id=379 size=241), 2, {:type=>"TwitterSearchRequest", :key=>"http"   }, #<Edamame::Scheduling::Recurring:0x176d094 @period=0.535726847370112, @prev_max=3290738573>]


      # # span of previous scrape
      # def prev_span
      #   @prev_span ||= UnionInterval.new(prev_span_min, prev_max)
      # end
      # def prev_span= min_max
      #   self.prev_span_min, self.prev_max = min_max.to_a
      #   @prev_span = UnionInterval.new(prev_span_min, prev_max)
      # end



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
