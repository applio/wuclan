class TwitterSearchJob < Edamame::Job
  #
  # Pagination
  #
  include Monkeyshines::ScrapeRequestCore::Paginating
  include Monkeyshines::ScrapeRequestCore::PaginatedWithLimit
  include Monkeyshines::ScrapeRequestCore::PaginatedWithRate
  # API max pages
  self.hard_request_limit   = 15

  # Items to get each re-visit. If there are up to 50 items per page,
  # target_items_per_job of 1000 will try to reschedule so that its return visit
  # makes about twenty page requests.
  #
  # For Twitter, 1500 is the max, so 1000 gives a safety margin.
  self.target_items_per_job = 1000

  # creates the paginated request
  def request_for_page page, info=nil
    req = TwitterSearchRequest.new(obj[:key], page)
    req.url << "&rpp=#{req.max_items}"
    req.url << "&max_id=#{sess_span.min - 1}" if sess_span.min
    req
  end
end
