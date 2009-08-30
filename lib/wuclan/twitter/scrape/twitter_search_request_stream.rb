
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

class TwitterSearchStream < Monkeyshines::RequestStream::EdamameQueue
  QUEUE_REQUEST_TIMEOUT = 2 # seconds

  def each *args, &block
    work(QUEUE_REQUEST_TIMEOUT) do |qjob|
      search_job = TwitterSearchJob.from_hash(qjob.obj)
      # do_faking(search_job)
      # p search_job
      search_job.each_request(*args, &block)
      qjob.scheduling.period = nil
    end
  end
end
