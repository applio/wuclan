
class TwitterRequestStream < Monkeyshines::RequestStream::SimpleRequestStream
  DEFAULT_REQUEST_SCOPE = Wuclan::Twitter::Scrape
  TwitterRequestStream::DEFAULT_OPTIONS = { :klass => TwitterUserRequest, }

  def initialize _options={}
    super _options
    self.request_klasses = options[:fetches]
  end

  # Set the list of follow-on requests
  #   'followers_ids,friends_ids'
  def request_klasses=(klass_names)
    @request_klasses = FactoryModule.list_of_classes(DEFAULT_REQUEST_SCOPE, klass_names, 'twitter', 'request').to_set
    @request_klasses.delete TwitterUserRequest
  end

  # Get the user and then get all other requested classes.
  # The user's parameters (followers_count, etc.) fix the items to request
  # The users' numeric ID replaces the supplied identifier (the first request
  # can be a screen_name, but we need the numeric ID for followers_request's, etc.
  def each_job twitter_user_id, *args
    user_req = TwitterUserRequest.new(twitter_user_id)
    yield(user_req)
    return unless user_req.healthy?
    twitter_user_id = user_req.parsed_contents['id'].to_i if (user_req.parsed_contents['id'].to_i > 0)
    @request_klasses.each do |request_klass|
      req = request_klass.new(twitter_user_id)
      req.set_total_items user_req.parsed_contents
      yield req
    end
  end

  #
  # for the given user_id,
  # gets the user
  # and then each of the requests in more_request_klasses
  #
  def each
    request_store.each do |*raw_job_args|
      self.each_job(*raw_job_args) do |job|
        job.each_request do |req|
          yield req
        end
      end
    end
  end
end
