
class TwitterSearchFakeFetcher < Monkeyshines::Fetcher::FakeFetcher
  cattr_accessor :items_rate
  def self.fake_time item_on_page, base=nil
    base ||= 86_400
    base - (item_on_page.to_f / items_rate)
  end

  def fake_contents req
    max_time = self.class.fake_time((req.page - 1) * 105)
    max_id   = max_time.to_i
    case req.query_term
    when '_no_results'
      return { :max_id => -1, :results => [],}
    when '_one_result'
      n_results = 1
    else
      n_results = 100
    end
    { :max_id    => max_id,
      # :next_page => "?page=2&max_id=#{max_id}&rpp=100&q=#{req.query_term}",
      :results   => (0 ... n_results).map{|i| {
          :text       => "%s-%04d-%03d"%[req.query_term, req.page, i],
          :created_at => Time.now - (86_400 - self.class.fake_time(i, max_time)),
          :id         => (self.class.fake_time(i, max_id)*100).to_i } }   }
  end

  def get req
    super req
    req.contents = fake_contents(req).to_json
    req
  end
end

# TwitterSearchStream.class_eval do
#   def do_faking job
#     TwitterSearchFakeFetcher.items_rate = job.prev_rate || 1
#     job.prev_span_max = (TwitterSearchFakeFetcher.fake_time(rand(15) * 105)*100).to_i
#     p [
#       job.prev_span_max,
#       TwitterSearchFakeFetcher.fake_time(0).to_i
#     ]
#   end
# end
