
#
# returns json for a hash / array as appropriate
#
class TwitterFakeFetcher < Monkeyshines::Fetcher::FakeFetcher

  def fake_contents req
    case req
    when TwitterFollowersIdsRequest, TwitterFriendsIdsRequest
      (1 .. rand(50)).map{ rand(1e6) }.to_json
    when TwitterUserRequest
      { :id => (req.twitter_user_id.to_i == 0 ? rand(1e6) : req.twitter_user_id),
        :created_at => Time.parse('08-08-2008 12:45'), :name => req.url, :protected => false,
        :followers_count => rand(2001), :friends_count => rand(401), :statuses_count => rand(120), :favourites_count => rand(50) }.to_json
    when TwitterFollowersRequest, TwitterFriendsRequest, TwitterFavoritesRequest
      (0..req.max_items).map{|i| { :fetched => req.url, :id => i } }.to_json
    else
      if (req[:page].to_i > 1) && (rand(8) == 0)
        [].to_json
      else
        (0..req.max_items).map{|i| { :fetched => req.url, :id => i } }.to_json
      end
    end
  end

  def get req
    super req
    req.contents = fake_contents(req)
    req
  end
end
