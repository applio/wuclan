# Generated by jeweler
# DO NOT EDIT THIS FILE
# Instead, edit Jeweler::Tasks in Rakefile, and run `rake gemspec`
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{wuclan}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Philip (flip) Kromer"]
  s.date = %q{2009-09-01}
  s.description = %q{Massive-scale social network analysis. Nothing to f with.}
  s.email = %q{flip@infochimps.org}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.textile"
  ]
  s.files = [
    "LICENSE",
     "README.textile",
     "Rakefile",
     "VERSION.yml",
     "lib/old/twitter_api.rb",
     "lib/wuclan.rb",
     "lib/wuclan/delicious/delicious_html_request.rb",
     "lib/wuclan/delicious/delicious_models.rb",
     "lib/wuclan/delicious/delicious_request.rb",
     "lib/wuclan/friendfeed/scrape/friendfeed_search_request.rb",
     "lib/wuclan/friendster.rb",
     "lib/wuclan/lastfm.rb",
     "lib/wuclan/lastfm/model/base.rb",
     "lib/wuclan/lastfm/model/sample_responses.txt",
     "lib/wuclan/lastfm/scrape.rb",
     "lib/wuclan/lastfm/scrape/base.rb",
     "lib/wuclan/lastfm/scrape/concrete.rb",
     "lib/wuclan/lastfm/scrape/lastfm_job.rb",
     "lib/wuclan/lastfm/scrape/lastfm_request_stream.rb",
     "lib/wuclan/lastfm/scrape/recursive_requests.rb",
     "lib/wuclan/metrics.rb",
     "lib/wuclan/metrics/user_graph_metrics.rb",
     "lib/wuclan/metrics/user_metrics.rb",
     "lib/wuclan/metrics/user_metrics_basic.rb",
     "lib/wuclan/metrics/user_scraping_metrics.rb",
     "lib/wuclan/myspace.rb",
     "lib/wuclan/open_social.rb",
     "lib/wuclan/open_social/api_overview.textile",
     "lib/wuclan/open_social/model/base.rb",
     "lib/wuclan/open_social/scrape/base.rb",
     "lib/wuclan/open_social/scrape_request.rb",
     "lib/wuclan/rdf_output/relationship_rdf.rb",
     "lib/wuclan/rdf_output/text_element_rdf.rb",
     "lib/wuclan/rdf_output/tweet_rdf.rb",
     "lib/wuclan/rdf_output/twitter_rdf.rb",
     "lib/wuclan/rdf_output/twitter_user_rdf.rb",
     "lib/wuclan/shorturl/shorturl_request.rb",
     "lib/wuclan/twitter.rb",
     "lib/wuclan/twitter/api_response_examples.textile",
     "lib/wuclan/twitter/model.rb",
     "lib/wuclan/twitter/model/base.rb",
     "lib/wuclan/twitter/model/multi_edge.rb",
     "lib/wuclan/twitter/model/relationship.rb",
     "lib/wuclan/twitter/model/text_element.rb",
     "lib/wuclan/twitter/model/text_element/extract_info_tests.rb",
     "lib/wuclan/twitter/model/text_element/grok_tweets.rb",
     "lib/wuclan/twitter/model/text_element/more_regexes.rb",
     "lib/wuclan/twitter/model/tweet.rb",
     "lib/wuclan/twitter/model/tweet/tokenize.rb",
     "lib/wuclan/twitter/model/tweet/tweet_regexes.rb",
     "lib/wuclan/twitter/model/tweet/tweet_token.rb",
     "lib/wuclan/twitter/model/twitter_user.rb",
     "lib/wuclan/twitter/model/twitter_user/style/color_to_hsv.rb",
     "lib/wuclan/twitter/parse/ff_ids_parser.rb",
     "lib/wuclan/twitter/parse/friends_followers_parser.rb",
     "lib/wuclan/twitter/parse/generic_json_parser.rb",
     "lib/wuclan/twitter/parse/json_tweet.rb",
     "lib/wuclan/twitter/parse/json_twitter_user.rb",
     "lib/wuclan/twitter/parse/public_timeline_parser.rb",
     "lib/wuclan/twitter/parse/user_parser.rb",
     "lib/wuclan/twitter/scrape.rb",
     "lib/wuclan/twitter/scrape/base.rb",
     "lib/wuclan/twitter/scrape/old_skool_request_classes.rb",
     "lib/wuclan/twitter/scrape/twitter_fake_fetcher.rb",
     "lib/wuclan/twitter/scrape/twitter_ff_ids_request.rb",
     "lib/wuclan/twitter/scrape/twitter_followers_request.rb",
     "lib/wuclan/twitter/scrape/twitter_json_response.rb",
     "lib/wuclan/twitter/scrape/twitter_request_stream.rb",
     "lib/wuclan/twitter/scrape/twitter_search_fake_fetcher.rb",
     "lib/wuclan/twitter/scrape/twitter_search_flat_stream.rb",
     "lib/wuclan/twitter/scrape/twitter_search_job.rb",
     "lib/wuclan/twitter/scrape/twitter_search_request.rb",
     "lib/wuclan/twitter/scrape/twitter_search_request_stream.rb",
     "lib/wuclan/twitter/scrape/twitter_timeline_request.rb",
     "lib/wuclan/twitter/scrape/twitter_user_request.rb"
  ]
  s.homepage = %q{http://github.com/mrflip/wuclan}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Massive-scale social network analysis. Nothing to f with.}
  s.test_files = [
    "spec/spec_helper.rb",
     "spec/wuclan_spec.rb",
     "examples/analyze/strong_links/gen_multi_edge.rb",
     "examples/analyze/strong_links/main.rb",
     "examples/analyze/word_count/dump_schema.rb",
     "examples/analyze/word_count/freq_user.rb",
     "examples/analyze/word_count/freq_whole_corpus.rb",
     "examples/analyze/word_count/word_count.rb",
     "examples/lastfm/scrape/load_lastfm.rb",
     "examples/lastfm/scrape/scrape_lastfm.rb",
     "examples/twitter/old/load_twitter_search_jobs.rb",
     "examples/twitter/old/scrape_twitter_api.rb",
     "examples/twitter/old/scrape_twitter_search.rb",
     "examples/twitter/old/scrape_twitter_trending.rb",
     "examples/twitter/parse/parse_twitter_requests.rb",
     "examples/twitter/scrape_twitter_api/scrape_twitter_api.rb",
     "examples/twitter/scrape_twitter_api/support/make_request_stats.rb",
     "examples/twitter/scrape_twitter_api/support/make_requests_by_id_and_date_1.rb",
     "examples/twitter/scrape_twitter_search/load_twitter_search_jobs.rb",
     "examples/twitter/scrape_twitter_search/scrape_twitter_search.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<wukong>, [">= 0"])
      s.add_runtime_dependency(%q<monkeyshines>, [">= 0"])
      s.add_runtime_dependency(%q<trollop>, [">= 0"])
    else
      s.add_dependency(%q<wukong>, [">= 0"])
      s.add_dependency(%q<monkeyshines>, [">= 0"])
      s.add_dependency(%q<trollop>, [">= 0"])
    end
  else
    s.add_dependency(%q<wukong>, [">= 0"])
    s.add_dependency(%q<monkeyshines>, [">= 0"])
    s.add_dependency(%q<trollop>, [">= 0"])
  end
end
