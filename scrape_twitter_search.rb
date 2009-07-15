#!/usr/bin/env ruby
$: << ENV['WUKONG_PATH']
require 'wukong'
require 'wukong/utils/filename_pattern'
require 'wuclan'
require 'monkeyshines'
require 'wuclan/domains/twitter'
require 'trollop' # gem install trollop

opts = Trollop::options do
  opt :from,      "Flat file of request parameters", :type => String
  opt :type,      "Class to instantiate from each line of the --from file, e.g. --type=ShortUrlHeadRequest", :type => String
  opt :dumpfile_dir, "Filename base to store output. e.g. --dump_basename=/data/ripd", :type => String
  opt :dumpfile_pattern, "Pattern for dump file output",
    :default => ":revdom/:date/:revdom+:datetime-:pid.tsv"
end

p opts # a hash: { :monkey => false, :goat => true, :num_limbs => 4, :num_thumbs => nil }

# Request type
Trolllop::die :type, "should give the class described in the --from file" if opts[:type].blank?
request_klass = Wukong.class_from_resource(opts[:type]) or Trolllop::die(:type, "isn't a class I can instantiate")

class TwitterSearchScrapable < Scrapable
  include PaginatedWithLimit
  include RawJsonContents
  attr_accessor :upper_limit, :lower_limit, :url_pattern
  attr_accessor :first_item_id, :last_item_id
  attr_accessor :first_item_at, :last_item_at, :num_items

  def initialize *args
    super *args
    self.num_items ||= 0
  end

  def acknowledge response
    first_item = response['results'].first
    last_item  = response['results'].last
    num_items  = response['results'].length
    self.first_item_at ||= Time.parse(first_item['created_at'])
    self.first_item_id ||= first_item['id']
    self.last_item_at    = Time.parse(last_item['created_at'])
    self.last_item_id    = last_item['id']
    self.num_items      += num_items
  end

  # "since_id":0,
  # "max_id":1480307926,
  # "refresh_url":"?since_id=1480307926&q=%40twitterapi",
  # "next_page":"?page=2&max_id=1480307926&q=%40twitterapi",
  def url
    # FIXME -- this fails unless qs is in place
    self.url_pattern + "&max_id=#{self.max_id}&since_id=#{self.min_id}"
  end

end

# Request stream
Trolllop::die :from, "should give the class described in the --from file"
request_stream = FlatFileRequestStream.new(opts[:from], TwitterSearchRequest)

# Scraper

# Store

#
# Whee! Get each request

search_term_requests.each do |search_term_request|
  new_lower_limit = nil
  search_term_request.each_page do |page_request|
    response = scraper.get(page_request)
    if response
      # save the response
      store.save response
    end
  end
  # store completed request with updated min_id
  completed_requests << search_term_request
end
