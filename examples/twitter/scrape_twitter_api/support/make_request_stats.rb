#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'wukong'
require 'monkeyshines'
require 'wuclan/twitter'
$: << '/home/flip/ics/rubygems/json-1.1.7/lib'
include Wuclan::Twitter::Scrape
include Wuclan::Twitter::Model


require 'wukong/schema'


Wuclan::Twitter::Scrape::Base.class_eval do
  extend Wukong::Schema
end

p Wuclan::Twitter::Scrape::TwitterUserRequest.pig_load

# Requests = LOAD 'ripd/com.tw/com.twitter/*' AS ( rsrc:chararray, priority:int, twitter_user_id: int, page: int, moreinfo: chararray, url: chararray, scraped_at: long, response_code: int, response_message: chararray, contents: chararray );
# request_classes = FOREACH Requests GENERATE rsrc, (int) ((double)scraped_at / 1000000.0) AS scon, response_code ;
# rc_grp = GROUP request_classes BY (rsrc, scon, response_code) ;
# rc_count = FOREACH rc_grp GENERATE COUNT(request_classes) AS freq, group.scon AS scraped_on, group.rsrc AS rsrc , group.response_code AS response_code ;
# rc_count_1 = ORDER rc_count BY scraped_on, rsrc, response_code ;
# rmf                    tmp/rc_count
# STORE rc_count_1 INTO 'tmp/rc_count' ;


# 20090304152029 bad utf8
# 20090308



#      1   9999999        20081207052456                    1             old_scraper     20081207052456  200     old_scraper     [{"user":{"followers_count":23,"description":"","url":"","profile_image_url":"http:\/\/s3.amazonaws.com /twi
#      1   9999999        20081207055023                    1             old_scraper     20081207055023  200     old_scraper     [{"user":{"followers_count":32,"description":"","url":"http:\/\/www.mychurch.org        /gervis","profile_image_url
#      1   9999999        20081209041619                    1             old_scraper     20081209041619  200     old_scraper     [{"user":{"followers_count":80,"description":"1983, Amersfoort, audio-producer @ NPS 3FM","url":"http:\/\/ww
#      1   9999999        20081209115725                    1             old_scraper     20081209115725  200     old_scraper     [{"user":{"followers_count":19,"description":"Pozzo e Luck nÃ£o acessavam a net.","url":"","profile_image_ur
#      1   9999999        20081209232718                    1             old_scraper     20081209232718  200     old_scraper     [{"user":{"followers_count":105,"description":"æ­å¹ââæ±äº¬é »ç¹ãITç³»,åºåç³»,ãã©ã³ãã¼,<E5><85>
#      1   9999999        20081210061628                    1             old_scraper     20081210061628  200     old_scraper     [{"user":{"followers_count":736,"description":"I AM","url":"http:\/\/www.frankvandun.nl","profile_image_url"
#      1   9999999        20081210185703                    1             old_scraper     20081210185703  200     old_scraper     [{"user":{"followers_count":644,"description":"Noticias de Chile actualizadas cada hora","url":"http:\/\/www
#      1   9999999        20081211095702                    1             old_scraper     20081211095702  200     old_scraper     [{"user":{"followers_count":64,"description":"","url":"http:\/\/tautin.blogspot.com     /","profile_image_url":"
#      1   9999999        20081213073636                    1             old_scraper     20081213073636  200     old_scraper     [{"user":{"followers_count":178,"description":"","url":"http:\/\/www.gazetadopovo.com.br","profile_image_url
#      1   9999999        20081214100003                    1             old_scraper     20081214100003  200     old_scraper     [{"user":{"followers_count":7,"description":"ResearchBlogging.org feeds in Deutsch","url":"http:\/\/research
#      1   9999999        20081215105211                    1             old_scraper     20081215105211  200     old_scraper     [{"user":{"followers_count":165,"description":"I am a stay-at-home mother of two, with one on the way! I am
#      1   9999999        20081218075108                    1             old_scraper     20081218075108  200     old_scraper     [{"user":{"followers_count":17,"description":"","url":"http:\/\/hard-hitting-news.blogspot.com  /","profile_i
#      1   9999999        20081219065853                    1             old_scraper     20081219065853  200     old_scraper     [{"user":{"followers_count":2,"description":"","url":"","profile_image_url":"http:\/\/static.twitter.com
#      1   9999999        20081220010525                    1             old_scraper     20081220010525  200     old_scraper     [{"user":{"followers_count":202,"description":null,"url":null,"profile_image_url":"http:\/\/static.twitter.c
#      1   9999999        20081220113649                    1             old_scraper     20081220113649  200     old_scraper     [{"user":{"followers_count":42,"description":"Contrary to popular belief, I am in fact a robot.","url":"http
#      1   9999999        20081221083623                    1             old_scraper     20081221083623  200     old_scraper     [{"user":{"followers_count":565,"description":"çãç³»ãã­ã°ã©ã","url":"http:\/\/polog.org      /","profi
#      1   9999999        20081224110505                    1             old_scraper     20081224110505  200     old_scraper     [{"user":{"followers_count":304,"description":"  A group of  green women bloggers, uniting our voices to hel
#      1   9999999        20081225055913                    1             old_scraper     20081225055913  200     old_scraper     [{"user":{"followers_count":213,"description":"åäººã²ã¼ã ä½ã£ã¦ã¾ããããæ°è»½ã«ãã©ã­ã¼<E3>
#      1   9999999        20081229072914                    1             old_scraper     20081229072914  200     old_scraper     [{"user":{"followers_count":15,"description":"","url":"http:\/\/www.rodia.info","profile_image_url":"http:
#      1   9999999        20081229084830                    1             old_scraper     20081229084830  200     old_scraper     [{"user":{"followers_count":191,"description":"3rd Generation Real Estate Investor and Author","url":"http:\
#      1   9999999        20090102103315                    1             old_scraper     20090102103315  200     old_scraper     [{"user":{"followers_count":21,"description":"takin over one city at a time","url":"","profile_image_url":"h
#      1   9999999        20090104084017                    1             old_scraper     20090104084017  200     old_scraper     [{"user":{"followers_count":299,"description":"ã¹ã¦ã£ã¼ãï¼åªï¼ã12æéããã¨ããã¦ãå°±<E5><AF>
#      1   9999999        20090105101608                    1             old_scraper     20090105101608  200     old_scraper     [{"user":{"followers_count":2171,"description":"LIVE wildlife 24\/7 from Djuma in South Africa. LIVE safari.
#      1   9999999        20090105103520                    1             old_scraper     20090105103520  200     old_scraper     [{"user":{"followers_count":19,"description":"Learning to dance like no one is watching","url":"","profile_i
#      1   9999999        20090106165730                    1             old_scraper     20090106165730  200     old_scraper     [{"user":{"followers_count":10,"description":"Live.Love.Laugh.","url":"","profile_image_url":"http:\/\/s3.am
#      1   9999999        20090112091101                    1             old_scraper     20090112091101  200     old_scraper     [{"user":{"followers_count":25,"description":"Ostravak je stav duÅ¡e, i kdyÅ¾ ÄlovÄk Å¾ije v Praze.","url"
#      1   9999999        20090117090748                    1             old_scraper     20090117090748  200     old_scraper     [{"user":{"followers_count":58,"description":"Moving on up.","url":"http:\/\/sarah-dear.blogspot.com","profi
#      1   9999999        20090418173317                    1             old_scraper     20090418173317  200     old_scraper     [{"user":{"followers_count":69,"description":"The Fail Whale is my spirit animal","url":"","profile_image_ur
#      1   9999999        20090418231828                    1             old_scraper     20090418231828  200     old_scraper     [{"user":{"followers_count":125,"description":"Cre@t!ve T!r@de","url":"","profile_image_url":"http:\/\/stati
#      1   9999999        20090419014909                    1             old_scraper     20090419014909  200     old_scraper     [{"user":{"followers_count":14,"description":"","url":"","profile_image_url":"http:\/\/static.twitter.com
#      1   9999999        20090419052121                    1             old_scraper     20090419052121  200     old_scraper     [{"user":{"followers_count":743,"description":"ãããæãã§åå ãã¦ã¿ã¾ãããéçã¨æ¸©æ³<E3>
#      1   9999999        20090419233942                    1             old_scraper     20090419233942  200     old_scraper     [{"user":{"followers_count":36,"description":"","url":"","profile_image_url":"http:\/\/static.twitter.com
#      1   9999999        20090420033745                    1             old_scraper     20090420033745  200     old_scraper     [{"user":{"followers_count":1815,"description":"Doing it for the girls baby, chicks, , ladies, women, Its ok
#      1   9999999        20090420112345                    1             old_scraper     20090420112345  200     old_scraper     [{"user":{"followers_count":13,"description":null,"url":null,"profile_image_url":"http:\/\/static.twitter.co
#      1   9999999        20090421010538                    1             old_scraper     20090421010538  200     old_scraper     [{"user":{"followers_count":30,"description":"There are those who think they can and those who think they ca
#      1   9999999        20090421084441                    1             old_scraper     20090421084441  200     old_scraper     [{"user":{"followers_count":119,"description":"web designer, photographer, musical genius","url":"","profile
#      1   9999999        20090421101818                    1             old_scraper     20090421101818  200     old_scraper     [{"user":{"followers_count":10,"description":"An eternal learner.  Master student in education : can wiki in
#      1   9999999        20090421232814                    1             old_scraper     20090421232814  200     old_fetcher     [{"user":{"followers_count":1,"description":null,"url":null,"profile_image_url":"http:\/\/static.twitter.com
#      1   9999999        20090422065945                    1             old_fetcher     20090422065945  200     old_fetcher     [{"user":{"followers_count":118,"description":"Curiosa, consultora de IT y madre a la vez!","url":"","profil
#      1   9999999        20090422083321                    1             old_fetcher     20090422083321  200     old_fetcher     [{"user":{"followers_count":14,"description":"","url":"http:\/\/www.myspace.com /sweetitdm","profile_image_u
#      1   9999999        20090423045905                    1             old_fetcher     20090423045905  200     old_fetcher     [{"user":{"followers_count":79,"description":"","url":"http:\/\/flickr.com      /photos\/malugreen","profile_imag
#      1   9999999        20090423063900                    1             old_fetcher     20090423063900  200     old_fetcher     [{"user":{"followers_count":388,"description":"Instructional technology grad student, dog lover, optimist,an
#      1   9999999        20090423135519                    1             old_fetcher     20090423135519  200     old_fetcher     [{"user":{"followers_count":628,"description":"MsBeat runs the show at Beatblogging.org. A news-savvy mistre
#      1   9999999        20090425052649                    1             old_fetcher     20090425052649  200     old_fetcher     [{"user":{"followers_count":12,"description":"mixiãã£ã¦ã¾ããããµãããããã§æ¤ç´¢ãã¦ã¿<E3>
#      1   9999999        20090426061449                    1             old_fetcher     20090426061449  200     old_fetcher     [{"user":{"followers_count":5,"description":"im in the land of soft drugs, legal whoring, windmills and tuli
#      1   9999999        20090428044727                    1             old_fetcher     20090428044727  200     old_fetcher     [{"user":{"followers_count":290,"description":"Online and Onair radioshow for geeks only!","url":"http:\/\/w
#      1   9999999        20090428151030                    1             old_fetcher     20090428151030  200     old_fetcher     [{"user":{"followers_count":520,"description":"The official home of New Zealand Rugby on Twitter","url":"htt
#      1   9999999        20090428232804                    1             old_fetcher     20090428232804  200     old_fetcher     [{"user":{"followers_count":3,"description":null,"url":null,"profile_image_url":"http:\/\/static.twitter.com
#      1   9999999        20090503152828                    1             old_fetcher     20090503152828  200     old_fetcher     [{"user":{"followers_count":49,"description":"","url":"http:\/\/www.myspace.com /silisali","profile_image_ur
#      1   9999999        20090503195932                    1             old_fetcher     20090503195932  200     old_fetcher     [{"user":{"followers_count":35,"description":"I am a national level bodybuilder working for Bodywell Nutriti
#      1   9999999        20090504020126                    1             old_fetcher     20090504020126  200     old_fetcher     [{"user":{"followers_count":35,"description":"Christian. Bass Player. Singer. Amateur Photographer. News Adv
#      1   9999999        20081209232718                    1             old_fetcher     20081209232718  200     old_fetcher     [{"user":{"followers_count":105,"description":"æ­å¹ââæ±äº¬é »ç¹ãITç³»,åºåç³»,ãã©ã³ãã¼,<E5><85>1   9999999        20081210061628                    1             old_fetcher     20081210061628  200     old_fetcher     [{"user":{"followers_count":736,"description":"I AM","url":"http:\/\/www.frankvandun.nl","profile_image_url"
#      1   9999999        20081210185703                    1             old_fetcher     20081210185703  200     old_fetcher     [{"user":{"followers_count":644,"description":"Noticias de Chile actualizadas cada hora","url":"http:\/\/www
#      1   9999999        20081211095702                    1             old_fetcher     20081211095702  200     old_fetcher     [{"user":{"followers_count":64,"description":"","url":"http:\/\/tautin.blogspot.com     /","profile_image_url":"  1   9999999        20081213073636                    1             old_fetcher     20081213073636  200     old_fetcher     [{"user":{"followers_count":178,"description":"","url":"http:\/\/www.gazetadopovo.com.br","profile_image_url
#      1   9999999        20081214100003                    1             old_fetcher     20081214100003  200     old_fetcher     [{"user":{"followers_count":7,"description":"ResearchBlogging.org feeds in Deutsch","url":"http:\/\/research
#      1   9999999        20081215105211                    1             old_fetcher     20081215105211  200     old_fetcher     [{"user":{"followers_count":165,"description":"I am a stay-at-home mother of two, with one on the way! I am
#      1   9999999        20081218075108                    1             old_fetcher     20081218075108  200     old_fetcher     [{"user":{"followers_count":17,"description":"","url":"http:\/\/hard-hitting-news.blogspot.com  /","profile_i
#      1   9999999        20081219065853                    1             old_fetcher     20081219065853  200     old_fetcher     [{"user":{"followers_count":2,"description":"","url":"","profile_image_url":"http:\/\/static.twitter.com
#         /im
#      1   9999999        20081220010525                    1             old_fetcher     20081220010525  200     old_fetcher     [{"user":{"followers_count":202,"description":null,"url":null,"profile_image_url":"http:\/\/static.twitter.c
#      1   9999999        20081220113649                    1             old_fetcher     20081220113649  200     old_fetcher     [{"user":{"followers_count":42,"description":"Contrary to popular belief, I am in fact a robot.","url":"http
#      1   9999999        20081221083623                    1             old_fetcher     20081221083623  200     old_fetcher     [{"user":{"followers_count":565,"description":"çãç³»ãã­ã°ã©ã","url":"http:\/\/polog.org      /","profi 1   9999999        20081224110505                    1             old_fetcher     20081224110505  200     old_fetcher     [{"user":{"followers_count":304,"description":"  A group of  green women bloggers, uniting our voices to hel
#      1   9999999        20081225055913                    1             old_fetcher     20081225055913  200     old_fetcher     [{"user":{"followers_count":213,"description":"åäººã²ã¼ã ä½ã£ã¦ã¾ããããæ°è»½ã«ãã©ã­ã¼<E3>   1   9999999        20081229072914                    1             old_fetcher     20081229072914  200     old_fetcher     [{"user":{"followers_count":15,"description":"","url":"http:\/\/www.rodia.info","profile_image_url":"http:
#       /
#      1   9999999        20081229084830                    1             old_fetcher     20081229084830  200     old_fetcher     [{"user":{"followers_count":191,"description":"3rd Generation Real Estate Investor and Author","url":"http:\
#      1   9999999        20090102103315                    1             old_fetcher     20090102103315  200     old_fetcher     [{"user":{"followers_count":21,"description":"takin over one city at a time","url":"","profile_image_url":"h
#      1   9999999        20090104084017                    1             old_fetcher     20090104084017  200     old_fetcher     [{"user":{"followers_count":299,"description":"ã¹ã¦ã£ã¼ãï¼åªï¼ã12æéããã¨ããã¦ãå°±<E5><AF>1   9999999        20090105101608                    1             old_fetcher     20090105101608  200     old_fetcher     [{"user":{"followers_count":2171,"description":"LIVE wildlife 24\/7 from Djuma in South Africa. LIVE safari.
#      1   9999999        20090105103520                    1             old_fetcher     20090105103520  200     old_fetcher     [{"user":{"followers_count":19,"description":"Learning to dance like no one is watching","url":"","profile_i
#      1   9999999        20090106165730                    1             old_fetcher     20090106165730  200     old_fetcher     [{"user":{"followers_count":10,"description":"Live.Love.Laugh.","url":"","profile_image_url":"http:\/\/s3.am
#      1   9999999        20090112091101                    1             old_fetcher     20090112091101  200     old_fetcher     [{"user":{"followers_count":25,"description":"Ostravak je stav duÅ¡e, i kdyÅ¾ ÄlovÄk Å¾ije v Praze.","url"
#      1   9999999        20090117090748                    1             old_fetcher     20090117090748  200     old_fetcher     [{"user":{"followers_count":58,"description":"Moving on up.","url":"http:\/\/sarah-dear.blogspot.com","profi
#      1   9999999        20090418173317                    1             old_fetcher     20090418173317  200     old_fetcher     [{"user":{"followers_count":69,"description":"The Fail Whale is my spirit animal","url":"","profile_image_ur
#      1   9999999        20090418231828                    1             old_fetcher     20090418231828  200     old_fetcher     [{"user":{"followers_count":125,"description":"Cre@t!ve T!r@de","url":"","profile_image_url":"http:\/\/stati
#      1   9999999        20090419014909                    1             old_fetcher     20090419014909  200     old_fetcher     [{"user":{"followers_count":14,"description":"","url":"","profile_image_url":"http:\/\/static.twitter.com
#      1   9999999        20090419052121                    1             old_fetcher     20090419052121  200     old_fetcher     [{"user":{"followers_count":743,"description":"ãããæãã§åå ãã¦ã¿ã¾ãããéçã¨æ¸©æ³<E3>
#      1   9999999        20090419233942                    1             old_fetcher     20090419233942  200     old_fetcher     [{"user":{"followers_count":36,"description":"","url":"","profile_image_url":"http:\/\/static.twitter.com
#      1   9999999        20090420033745                    1             old_fetcher     20090420033745  200     old_fetcher     [{"user":{"followers_count":1815,"description":"Doing it for the girls baby, chicks, , ladies, women, Its ok
#      1   9999999        20090420112345                    1             old_fetcher     20090420112345  200     old_fetcher     [{"user":{"followers_count":13,"description":null,"url":null,"profile_image_url":"http:\/\/static.twitter.co
#      1   9999999        20090421010538                    1             old_fetcher     20090421010538  200     old_fetcher     [{"user":{"followers_count":30,"description":"There are those who think they can and those who think they ca
#      1   9999999        20090421084441                    1             old_fetcher     20090421084441  200     old_fetcher     [{"user":{"followers_count":119,"description":"web designer, photographer, musical genius","url":"","profile
#      1   9999999        20090421101818                    1             old_fetcher     20090421101818  200     old_fetcher     [{"user":{"followers_count":10,"description":"An eternal learner.  Master student in education : can wiki in
#      1   9999999        20090421232814                    1             old_fetcher     20090421232814  200     old_fetcher     [{"user":{"followers_count":1,"description":null,"url":null,"profile_image_url":"http:\/\/static.twitter.com
#      1   9999999        20090422065945                    1             old_fetcher     20090422065945  200     old_fetcher     [{"user":{"followers_count":118,"description":"Curiosa, consultora de IT y madre a la vez!","url":"","profil
#      1   9999999        20090422083321                    1             old_fetcher     20090422083321  200     old_fetcher     [{"user":{"followers_count":14,"description":"","url":"http:\/\/www.myspace.com /sweetitdm","profile_image_u
#      1   9999999        20090423045905                    1             old_fetcher     20090423045905  200     old_fetcher     [{"user":{"followers_count":79,"description":"","url":"http:\/\/flickr.com      /photos\/malugreen","profile_imag
#      1   9999999        20090423063900                    1             old_fetcher     20090423063900  200     old_fetcher     [{"user":{"followers_count":388,"description":"Instructional technology grad student, dog lover, optimist,an
#      1   9999999        20090423135519                    1             old_fetcher     20090423135519  200     old_fetcher     [{"user":{"followers_count":628,"description":"MsBeat runs the show at Beatblogging.org. A news-savvy mistre
#      1   9999999        20090425052649                    1             old_fetcher     20090425052649  200     old_fetcher     [{"user":{"followers_count":12,"description":"mixiãã£ã¦ã¾ããããµãããããã§æ¤ç´¢ãã¦ã¿<E3>
#      1   9999999        20090426061449                    1             old_fetcher     20090426061449  200     old_fetcher     [{"user":{"followers_count":5,"description":"im in the land of soft drugs, legal whoring, windmills and tuli
#      1   9999999        20090428044727                    1             old_fetcher     20090428044727  200     old_fetcher     [{"user":{"followers_count":290,"description":"Online and Onair radioshow for geeks only!","url":"http:\/\/w
#      1   9999999        20090428151030                    1             old_fetcher     20090428151030  200     old_fetcher     [{"user":{"followers_count":520,"description":"The official home of New Zealand Rugby on Twitter","url":"htt
#      1   9999999        20090428232804                    1             old_fetcher     20090428232804  200     old_fetcher     [{"user":{"followers_count":3,"description":null,"url":null,"profile_image_url":"http:\/\/static.twitter.com
#      1   9999999        20090503152828                    1             old_fetcher     20090503152828  200     old_fetcher     [{"user":{"followers_count":49,"description":"","url":"http:\/\/www.myspace.com /silisali","profile_image_ur
#      1   9999999        20090503195932                    1             old_fetcher     20090503195932  200     old_fetcher     [{"user":{"followers_count":35,"description":"I am a national level bodybuilder working for Bodywell Nutriti
#      1   9999999        20090504020126                    1             old_fetcher     20090504020126  200     old_fetcher     [{"user":{"followers_count":35,"description":"Christian. Bass Player. Singer. Amateur Photographer. News Adv
#      1   9999999        20090504045337                    1             old_fetcher     20090504045337  200     old_fetcher     [{"user":{"followers_count":171,"description":"i'm a bboy and a multimedia designer","url":"http:\/\/pitiscm
#      1   9999999        20090507112755                    1             old_fetcher     20090507112755  200     old_fetcher     [{"user":{"followers_count":2,"description":"","url":"","profile_image_url":"http:\/\/static.twitter.com
#      1   9999999        20090509222228                    1             old_fetcher     20090509222228  200     old_fetcher     [{"user":{"followers_count":256,"description":"representing NJ\/NY","url":"http:\/      /www.myspace.com\/darknes
#      1   9999999        20090512052820                    1             old_fetcher     20090512052820  200     old_fetcher     [{"user":{"followers_count":0,"description":null,"url":null,"profile_image_url":"http:\/\/static.twitter.com
#      1   9999999        20090512101017                    1             old_fetcher     20090512101017  200     old_fetcher     [{"user":{"followers_count":685,"description":"Gainfully employed doing Linux 'stuff', part-time fitness fan
#      1   9999999        20090513062843                    1             old_fetcher     20090513062843  200     old_fetcher     [{"user":{"followers_count":7,"description":"Non-commercial radio for everyone who loves original music and
#
#      1  20090427        followers_ids                   200     /images\/themes\/theme1\/bg.gif","profile_link_color":"0000ff","time_zone":"Cairo","created_at":"Sun Sep 02 13:44:12 +0000 2007","profile_sidebar_fill_c
#      1  20090427        followers_ids                   200
#      1  20090427        followers_ids                   209     /help.twitter.com\/index.php?pg=kb.page&id=75\">txt<\/a>","created_at":"Sun Feb 08 08:17:30 +0000 2009"},{"user":{"profile_background_image_url":"http:\
#      1  20090427        followers_ids                    20     /twitter_production\/profile_images\/62248324\/086_copy_3_normal.jpg","statuses_count":16,"profile_text_color":"666666","screen_name":"cheekydonkey","pr
#      1  20090427        followers_ids                    20     /images\/themes\/theme1\/bg.gif","created_at":"Fri Apr 18 19:34:26 +0000 2008","profile_text_color":"000000","location":null,"id":14436644,"time_zone":"
#      1  20090427        followers_ids                   242
#      1  20090427        followers_ids                   24479801
#      1  20090427        followers_ids                     2     /images\/default_profile_normal.png","statuses_count":0,"profile_text_color":"000000","screen_name":"kaylazastrow","profile_background_tile":false,"prof
#   3256  20090427        followers_ids                   400
#
#      1         0        .subpage #content ol, #side ol { padding-left: 30px; }     a{text-decoration:none;color: #0084b4;}     #content div.desc { margin: 11px 0px 10px 0px; }     a img{border:0;}     ul{list
#      1         0        ":0,"profile_background_color":"9ae4e8","profile_background_image_url":"http:\/\/static.twitter.com       0
#      1         0        "profile_image_url":"http:\/\/s3.amazonaws.com    0
#      1         0        ,"favourites_count":0,"profile_background_color":"f8eb8b","profile_image_url":"http:\/\/static.twitter.com        0
#      1         0        /static.twitter.com\/images\/default_profile_normal.png","notifications":false,"statuses_count":6,"profile_sidebar_border_color":"87bc44","screen_name":"JoeLorah","profile_background_t
#      1         0        6}
#      1         0        _background_image_url":"http:\/\/s3.amazonaws.com         0
#      1         0        _color":"000000","url":null,"name":"Brett Speth","time_zone":null,"protected":false,"profile_link_color":"0000ff","followers_count":0,"profile_sidebar_fill_color":"e0ff92","profile_ima
#
#      1         0        .subpage #content ol, #side ol { padding-left: 30px; }     a{text-decoration:none;color: #0084b4;}     #content div.desc { margin: 11px 0px 10px 0px; }     a img{border:0;}     ul{list
#      1         0        ":0,"profile_background_color":"9ae4e8","profile_background_image_url":"http:\/\/static.twitter.com       0
#      1         0        "profile_image_url":"http:\/\/s3.amazonaws.com    0
#      1         0        ,"favourites_count":0,"profile_background_color":"f8eb8b","profile_image_url":"http:\/\/static.twitter.com        0
#      1         0        /static.twitter.com\/images\/default_profile_normal.png","notifications":false,"statuses_count":6,"profile_sidebar_border_color":"87bc44","screen_name":"JoeLorah","profile_background_t
#      1         0        6}
#      1         0        _background_image_url":"http:\/\/s3.amazonaws.com         0
#      1         0        _color":"000000","url":null,"name":"Brett Speth","time_zone":null,"protected":false,"profile_link_color":"0000ff","followers_count":0,"profile_sidebar_fill_color":"e0ff92","profile_ima
#    572         0        bogus-all_numeric-favorites     200
#      8         0        bogus-bad_chars-favorites       200
#     11         0        bogus-bad_chars-followers       200
#      3         0        bogus-bad_chars-friends         200
#   1867         0        bogus-missing_id-favorites      200
#      1         0        eply_to_status_id":null,"source":"web"},"notifications":false,"profile_image_url":"http:\/\/s3.amazonaws.com      0
#      1         0        f.com/friends/ids/17799430.json
#      1         0        f49.json
#      1         0        f81852492\/Bread__normal.jpg","status":{"truncated":false,"in_reply_to_status_id":1625610632,"text":"@podcasthelper oh yes yes i do still need help. It is ok to call upon your expertis
#      1         0        fat":"Tue Aug 12 15:27:32 +0000 2008","friends_count":87,"profile_background_color":"FF6699","location":"Newcastle, UK","id":15823576,"time_zone":"Hawaii","favourites_count":0,"profile
# 890016         0        favorites                       200
#      1         0        file_image_url":"http:\/\/static.twitter.com      0
#      1         0        fo:null,"name":"THE_REAL_SHAQ","protected":false,"profile_image_url":"http:\/\/s3.amazonaws.com   0
#      1         0        foll3183,14885034,17824762,25320311,26651936,5520952,16092530,15466712,18414465,20019951,22151420,26332254,7096192,13434972,26275705,27923225,15770739,19900326,15654216,20486512,167358
#      1         0        folleply_to_screen_name":null,"id":1618358723,"source":"<a href=\"http:\/         0
#      1         0        follo54:45 +0000 2009"}]
#      1         0        follos\/71101463\/LegalTimes_1651_normal.jpg","status":{"truncated":false,"in_reply_to_status_id":null,"text":"The Morning Wrap http:     0
#      1         0        followeada)","favourites_count":1,"profile_text_color":"666666"},{"description":"Writer, Pick-up Artist, Social Mastermind, and Traveler","profile_background_image_url":"http:\/\/stati
#      1         0        followekground_tile":false,"description":"Gamer\/Skier\/Drummer   0
#      1         0        followers,"profile_sidebar_border_color":"87bc44","time_zone":"London","profile_image_url":"http:\/\/s3.amazonaws.com     0
#      1         0        followers,12836312,18993475,16860914,16142878,18504804,17810432,18661758,17356420,17901504,15535360,19240090,16180026,14614833,18264863,17807744,19459418,19356460,8112832,18637695,1925
#      1         0        followers.json
#      1         0        followers_":"need coffee","favorited":false,"in_reply_to_screen_name":null,"created_at":"Mon Apr 27 14:11:52 +0000 2009","truncated":false,"id":1629096949,"in_reply_to_status_id":null,
#      1         0        followers__Close_normal.JPG","status":{"truncated":false,"in_reply_to_status_id":null,"text":"is finally home and going to bed. Have to get up for work in about 4.5 hours.","in_reply_t
#      1         0        followers_id                      0
#      1         0        followers_id,"profile_background_color":"9ae4e8","profile_image_url":"http:\/\/s3.amazonaws.com   0
#      1         0        followers_id13165892,15131310,6970122,13838022,15136098,14590445,15184346,6264392,12650292,16159919,16725668,16816616,15984607,16895930,12228062,15224867,859221,12364022,15316113,15624
#      1         0        followers_id2009","truncated":false,"id":1625606751,"in_reply_to_status_id":1623299478,"source":"web"},"notifications":false,"time_zone":"Pacific Time (US & Canada)","favourites_count"
#      1         0        followers_idbackground_tile":false,"followers_count":78,"url":"http:\/\/danfitek.com","screen_name":"fitekker","name":"Dan Fitek","friends_count":100,"profile_background_color":"9ae4e8
#    149         0        followers_ids
#      1         0        followers_ids                     1
#      1         0        followers_ids                   17975054
#      1         0        followers_ids                   200
#      1         0        followers_ids                   20090412070434
#      4         0        followers_ids                     0
#      1         0        followers_ids                     0
#      1         0        followers_ids                     0
#      1         0        followers_ids"in_reply_to_screen_name":null,"created_at":"Fri Apr 24 19:22:24 +0000 2009","truncated":false,"id":1606556267,"in_reply_to_status_id":null,"source":"<a href=\"http:\/      0
#      1         0        followers_ids00,"profile_link_color":"0000ff","profile_image_url":"http:\/\/static.twitter.com    0
#      1         0        followers_idsC2EF","location":"San Diego, CA","id":9628922,"time_zone":"Pacific Time (US & Canada)","created_at":"Tue Oct 23 17:30:49 +0000 2007"}]
#      1         0        followers_idst":"Mon Jan 28 03:48:51 +0000 2008","screen_name":"siolanthe"},{"description":"","profile_background_image_url":"http:\/\/static.twitter.com         0
#      1         0        followers_ilocation":null,"id":15311449,"time_zone":"Greenland"},{"description":"","profile_background_image_url":"http:\/\/s3.amazonaws.com      0
#      1         0        followerwing":false,"profile_link_color":"CD0033","url":"http:\/\/foodfeed.us","name":"FoodFeed","notifications":false,"profile_sidebar_fill_color":"fafaf5","followers_count":4399,"pro
#      1         0        followetp://twitter.com/followers/ids/15737773.json
#      1         0        fri:5,"profile_sidebar_border_color":"87bc44","url":null,"screen_name":"seniorpoopypant","name":"seniorpoopypant","favourites_count":0,"protected":false,"status":{"truncated":false,"in
#      1         0        frie:"Pirate LadyZebra. (also know as Zoaea)","utc_offset":-18000,"profile_sidebar_fill_color":"e0ff92","followers_count":19,"favourites_count":0,"profile_image_url":"http:\/\/s3.amazo
#      1         0        friend219,14213042,29736155,27530456,18755292]
#      1         0        friends":"web"},"profile_background_image_url":"http:\/\/static.twitter.com       0
#      1         0        friends\/\/s3.amazonaws.com       0
#      1         0        friends_3,27039226,29988381,35486899,18900303,16044047]
#      1         0        friends__count":0,"profile_background_color":"9ae4e8","profile_image_url":"http:\/\/s3.amazonaws.com      0
#      1         0        friends_i12809262,12767592,13084172,12803292,12775072,12129872,14198789,29866309]
#      1         0        friends_i1355,"source":"web","created_at":"Fri Jun 27 20:51:55 +0000 2008"},{"truncated":false,"user":{"description":"Recently married!  Work for Victory - vc.tv - lovin' life!","utc_o
#      1         0        friends_id":null,"text":"One Laptop per Child Lands in Indiahttp:\/\/tinyurl.com          0
#      1         0        friends_id,17213487,20820391,1050851,23817210,15117375,14790735,16069532,14634720,23306376,14470037,24754635,18666525,16798949,17118708,17492127,16563598,22731226,20253928,17139092,240
#      1         0        friends_idile_background_images\/3476247\/BJMendelson_388_twitbacks.jpg","profile_link_color":"0084B4","location":"Glens Falls, New York","id":12687952,"time_zone":"Indiana (East)","cr
#    161         0        friends_ids
#      1         0        friends_ids                     18706826
#      1         0        friends_ids                     16624466
#      1         0        friends_ids                     20090427091534
#      1         0        friends_ids                     20090427094351
#      1         0        friends_ids                       0
#      1         0        friends_ids                       0
#      1         0        friends_ids                       0
#      1         0        friends_ids                       0
#      1         0        friends_ids                       0
#      1         0        friends_ids                       0
#      1         0        friends_ids/\/orangatame.com\/products    0
#      1         0        friends_idsl_color":"F3F3F3","followers_count":25,"location":"St. Louis","id":14708168,"notifications":false,"friends_count":23,"profile_sidebar_border_color":"DFDFDF"},"text":"@Raptor
#      1         0        friends_iound_images\/4821472\/Mississippi_River_TypeMap2.jpg","profile_link_color":"1F98C7","location":"San Francisco","id":18257438,"time_zone":"Pacific Time (US & Canada)","created_
#      1         0        friprofile_background_color":"1A1B1F","protected":false,"profile_image_url":"http:\/\/s3.amazonaws.com    0
#      1         0        frmusings of a young Catholic in Yorkshire, England","utc_offset":0,"notifications":false,"profile_sidebar_fill_color":"e0ff92","followers_count":89,"profile_image_url":"http:\/\/s3.am
#      1         0        frollowing":false,"statuses_count":468,"profile_link_color":"2FC2EF","url":"http:\/\/myspace.com          0
#      1         0        fws.com\/twitter_production\/profile_background_images    0
#      1         0        hu Mar 05 07:45:42 +0000 2009","id":1282474011,"in_reply_to_status_id":null,"source":"web"},"profile_sidebar_border_color":"C6E2EE","notifications":false,"created_at":"Thu Mar 05 07:36
#      1         0        ile_image_url":"http:\/\/static.twitter.com       0
#      1         0        imit exceeded. Clients may not make more than 20000 requests per hour."}
#      1         0        location":null,"id":22893663,"profile_link_color":"0000ff"}
#      1         0        nk faudrait demander \u00e0 Michel Bergeron ,on aurait du fun pour 30 minutes","in_reply_to_user_id":21818830,"created_at":"Wed Mar 04 19:18:53 +0000 2009","truncated":false,"id":12798
#      1         0        oz","profile_background_image_url":"http:\/\/static.twitter.com   0
#      1         0        s football, beer, and technology!  Tweet away!","statuses_count":1444,"utc_offset":-21600,"profile_sidebar_border_color":"87bc44","profile_background_tile":true,"following":false,"prof
#  24228         0        timeline                        200
#      1         0        u"created_at":"Wed Mar 04 05:45:20 +0000 2009","in_reply_to_user_id":null,"in_reply_to_status_id":null,"truncated":false,"id":1277431048,"source":"<a href=\"http:\/      0
#      1         0        u128
#      1         0        u88,"in_reply_to_status_id":null,"source":"web"},"profile_sidebar_border_color":"F2E195","notifications":false,"created_at":"Wed Mar 04 05:32:57 +0000 2009","profile_background_image_u
#      1         0        uat":"Thu Mar 05 09:07:06 +0000 2009","id":1282640319,"in_reply_to_status_id":null,"source":"web"},"profile_sidebar_border_color":"87bc44","notifications":false,"created_at":"Thu Mar 0
#      1         0        ul":null,"name":"kimberly luzier","profile_background_tile":false,"protected":false,"status":{"in_reply_to_user_id":null,"text":"pictures for ebayy","created_at":"Thu Mar 05 17:21:37 +
#      1         0        us":"http:\/\/s3.amazonaws.com    0
#      1         0        us":false,"location":null,"id":22740024}
#      1         0        us0308222713
#      1         0        use":2,"url":"http:\/\/www.pat-bach.com","name":"Tim Bach","profile_background_tile":false,"protected":false,"status":{"truncated":false,"favorited":false,"text":"Setting up my Twitter
#      1         0        use,"id":1288256641,"in_reply_to_status_id":null,"source":"web"},"profile_sidebar_border_color":"87bc44","notifications":false,"created_at":"Thu Mar 05 08:33:22 +0000 2009","profile_ba
#      1         0        usefalse,"favorited":false,"text":"Wondering what twitter is all about and if I am missing out!","in_reply_to_user_id":null,"created_at":"Tue Mar 03 13:21:30 +0000 2009","id":127364277
#      1         0        useme":"magic 93.1 Radio","profile_background_image_url":"http:\/\/s3.amazonaws.com       0
#      1         0        useprofile_text_color":"000000","description":null,"screen_name":"JohnNMiller","utc_offset":null,"profile_link_color":"0000ff","time_zone":null,"profile_sidebar_fill_color":"e0ff92","f
#
#    474         0        user
#      1         0        user                            20104991
#      2         0        user                              1
#      1         0        user                            14686512
#     80         0        user                            200
#      1         0        user                            20090308201437
#      1         0        user                            20090308201710
#      1         0        user                            20090308201901
#      1         0        user                            20090308202228
#      1         0        user                            20090308204043
#      1         0        user                            20090308214100
#      8         0        user                              0
#      1         0        user                              0
#      1         0        user                              0
#      1         0        user                              0
#      1         0        user                              0
#      1         0        user                              0
#      1         0        user                              0
#      1         0        user                              0
#      1         0        user                              0     /lovechelle","name":"nichellemicole","profile_background_tile":false,"protected":true,"profile_sidebar_border_color":"D9B17E","notifications":false,"cre
#      1         0        user                              0     /images\/themes\/theme1\/bg.gif","statuses_count":1,"profile_text_color":"000000","time_zone":null,"url":null,"name":"Ben Pitz","friends_count":10,"prof
#      1         0        user                              0     /help.twitter.com\/index.php?pg=kb.page&id=75\">txt<\/a>"},"notifications":false,"profile_image_url":"http:\/\/static.twitter.com\/images\/default_profi
#      1         0        user Ocean from my office window.","favorited":false,"created_at":"Wed Feb 25 15:55:00 +0000 2009","in_reply_to_user_id":null,"id":1249633057,"source":"web"},"time_zone":null,"profile_
#      5         0        user_timeline
#      1         0        user_timeline                     0
#      1         0        userr.com\/images\/default_profile_normal.png","followers_count":3,"location":null,"id":21311967,"created_at":"Thu Feb 19 16:16:04 +0000 2009","profile_sidebar_border_color":"87bc44","
#      1         0        usertp:\/\/orangatame.com         0
#      1         0        usertter_production\/profile_images\/87717775     0
#      1         0        usm/users/show/0022897534.json?page=1
#      1         0        usmtwittercom.html\">mobile web<\/a>"},"profile_sidebar_border_color":"87bc44","notifications":false,"created_at":"Tue Sep 02 07:53:34 +0000 2008","profile_background_image_url":"http:
#      8  20081218        bogus-all_numeric-followers     200
#     12  20081218        bogus-all_numeric-friends       200
# :
