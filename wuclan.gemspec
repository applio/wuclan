# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{wuclan}
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Philip (flip) Kromer"]
  s.date = %q{2009-07-07}
  s.description = %q{Massive-scale social network analysis. Nothing to f with.}
  s.email = %q{flip@infochimps.org}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.textile"
  ]
  s.files = [
    ".document",
     ".gitignore",
     ".gitmodules",
     "LICENSE",
     "README.textile",
     "Rakefile",
     "VERSION.yml",
     "docs/wuclan_class_overview.graffle",
     "examples/strong_links/gen_multi_edge.rb",
     "examples/strong_links/main.rb",
     "examples/word_count/dump_schema.rb",
     "examples/word_count/freq_user.rb",
     "examples/word_count/freq_whole_corpus.rb",
     "examples/word_count/word_count.pig",
     "examples/word_count/word_count.rb",
     "lib/wuclan.rb",
     "lib/wuclan/domains/delicious/delicious_html_request.rb",
     "lib/wuclan/domains/delicious/delicious_models.rb",
     "lib/wuclan/domains/delicious/delicious_request.rb",
     "lib/wuclan/domains/shorturl/shorturl_request.rb",
     "lib/wuclan/domains/twitter.rb",
     "lib/wuclan/domains/twitter/model_common.rb",
     "lib/wuclan/domains/twitter/multi_edge.rb",
     "lib/wuclan/domains/twitter/relationship.rb",
     "lib/wuclan/domains/twitter/text_element.rb",
     "lib/wuclan/domains/twitter/text_element/extract_info_tests.rb",
     "lib/wuclan/domains/twitter/text_element/grok_tweets.rb",
     "lib/wuclan/domains/twitter/text_element/more_regexes.rb",
     "lib/wuclan/domains/twitter/tweet.rb",
     "lib/wuclan/domains/twitter/tweet/tokenize.rb",
     "lib/wuclan/domains/twitter/tweet/tweet_regexes.rb",
     "lib/wuclan/domains/twitter/tweet/tweet_token.rb",
     "lib/wuclan/domains/twitter/twitter_user.rb",
     "lib/wuclan/domains/twitter/twitter_user/style/color_to_hsv.rb",
     "lib/wuclan/metrics/user_graph_metrics.rb",
     "lib/wuclan/metrics/user_metrics.rb",
     "lib/wuclan/metrics/user_metrics_basic.rb",
     "lib/wuclan/metrics/user_scraping_metrics.rb",
     "lib/wuclan/rdf_output/relationship_rdf.rb",
     "lib/wuclan/rdf_output/text_element_rdf.rb",
     "lib/wuclan/rdf_output/tweet_rdf.rb",
     "lib/wuclan/rdf_output/twitter_rdf.rb",
     "lib/wuclan/rdf_output/twitter_user_rdf.rb",
     "lib/wuclan/request.rb",
     "lib/wuclan/request/base.rb",
     "lib/wuclan/request/parse.rb",
     "lib/wuclan/request/parse/ff_ids_parser.rb",
     "lib/wuclan/request/parse/friends_followers_parser.rb",
     "lib/wuclan/request/parse/generic_json_parser.rb",
     "lib/wuclan/request/parse/json_tweet.rb",
     "lib/wuclan/request/parse/json_twitter_user.rb",
     "lib/wuclan/request/parse/public_timeline_parser.rb",
     "lib/wuclan/request/parse/user_parser.rb",
     "lib/wuclan/request/scrape/expanded_url.rb",
     "lib/wuclan/request/scrape/http_scraper.rb",
     "lib/wuclan/request/scrape/old_scrape_request.rb",
     "lib/wuclan/request/scrape/scrape_dumper.rb",
     "lib/wuclan/request/scrape/scrape_request.rb",
     "lib/wuclan/request/scrape/scrape_store.rb",
     "lib/wuclan/request/scrape/scraped_file.rb",
     "lib/wuclan/request/scrape/twitter_api.rb",
     "lib/wuclan/request/scrape/twitter_search_scraper.rb",
     "lib/wuclan/request/streamer.rb",
     "lib/wuclan/request/twitter_api.rb",
     "scrape_twitter.rb",
     "spec/spec_helper.rb",
     "spec/wuclan_spec.rb"
  ]
  s.homepage = %q{http://github.com/mrflip/wuclan}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{Massive-scale social network analysis. Nothing to f with.}
  s.test_files = [
    "spec/spec_helper.rb",
     "spec/wuclan_spec.rb",
     "examples/strong_links/gen_multi_edge.rb",
     "examples/strong_links/main.rb",
     "examples/word_count/dump_schema.rb",
     "examples/word_count/freq_user.rb",
     "examples/word_count/freq_whole_corpus.rb",
     "examples/word_count/word_count.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mrflip-wukong>, [">= 0"])
      s.add_runtime_dependency(%q<mrflip-monkeyshines>, [">= 0"])
      s.add_runtime_dependency(%q<trollop>, [">= 0"])
    else
      s.add_dependency(%q<mrflip-wukong>, [">= 0"])
      s.add_dependency(%q<mrflip-monkeyshines>, [">= 0"])
      s.add_dependency(%q<trollop>, [">= 0"])
    end
  else
    s.add_dependency(%q<mrflip-wukong>, [">= 0"])
    s.add_dependency(%q<mrflip-monkeyshines>, [">= 0"])
    s.add_dependency(%q<trollop>, [">= 0"])
  end
end
