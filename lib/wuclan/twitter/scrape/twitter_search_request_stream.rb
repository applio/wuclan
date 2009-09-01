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
    end
  end
end

