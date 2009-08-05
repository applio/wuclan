# module Wuclan
#     module Twitter
#       module Scrape
#         #
#         # ScrapeRequest for the twitter Search API.
#         #
#         # Examines the parsed contents to describe result
#         #
#         class TwitterSearchRequest < Monkeyshines::ScrapeRequest
#           include Monkeyshines::RawJsonContents
#           # Extract the actual search items returned
#           def items
#             parsed_contents['results'] if parsed_contents
#           end
#           # Checks that the response parses and has the right data structure.
#           # if healthy? is true things should generally work
#           def healthy?
#             items && items.is_a?(Array)
#           end
#           # Number of items returned in this request
#           def num_items()
#             items ? items.length : 0
#           end
#           # Span of IDs. Assumes the response has the ids in sort order oldest to newest
#           # (which the twitter API provides)
#           def span
#             [items.last['id'], items.first['id']] rescue nil
#           end
#           # Span of created_at times covered by this request.
#           # Useful for rate estimation.
#           def timespan
#             [Time.parse(items.last['created_at']), Time.parse(items.first['created_at'])] rescue nil
#           end
#         end
#       end
#     end
#   end
# end



# class FriendFeedSearchFetcher
#   def search_url query, page, max_id
#     start = (page-1)*100
#     %Q{http://friendfeed.com/api/feed/search?q=#{query}&service=twitter&start=#{start}&num=100}
#   end
#   def max_results_per_page
#     100
#   end
#   def max_page
#     4
#   end
#   def terminate? response, page
#     terminate = super || page >= max_page
#   end
#   def get_results response
#     response['entries'] if response
#   end
# end

