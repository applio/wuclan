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
