aor1hd_ids = LOAD 'meta/aorf/nbhd/aor1hd_ids_1.tsv' AS (id:int) ;
TwitterUserId           = LOAD    'twall/all/twitter_user_id' AS (rsrc: chararray, id: int, screen_name: chararray, full: int, followers_count: int, created_at: long, protected: int, status: chararray) ;
TwitterUser             = LOAD    'twall/all/twitter_user' AS (rsrc: chararray, id: int, scraped_at: long, screen_name: chararray, protected: int, followers_count: int, friends_count: int, statuses_count: int, favourites_count: int, created_at: long) ;


-- aor_users_0 = JOIN aor1hd_ids BY id, TwitterUser BY id;
-- aor_users_1 = FOREACH aor_users_0 GENERATE
--   rsrc, TwitterUser::id, scraped_at, screen_name, protected, followers_count, friends_count, statuses_count, favourites_count, created_at ;
--   ;
-- rmf meta/aorf/nbhd/aor1hd_users  ; STORE aor_users_1 INTO 'meta/aorf/nbhd/aor1hd_users';

-- AFollowsB               = LOAD    'twall/all/a_follows_b' AS (rsrc: chararray, user_a_id: int, user_b_id: int) ;
-- aor_a_follows_b_0 = JOIN aor1hd_ids BY id, AFollowsB BY user_a_id;
-- aor_a_follows_b_1   = FOREACH aor_a_follows_b_0 GENERATE user_a_id, user_b_id ;
-- rmf meta/aorf/nbhd/aor_2hd_o ; STORE aor_a_follows_b_1 INTO 'meta/aorf/nbhd/aor_2hd_o';  

-- aor1hd_ids = LOAD 'meta/aorf/nbhd/aor1hd_ids_1.tsv' AS (id:int) ;
-- toks = LOAD 'meta/aorf/word_count/tokens' AS (word:chararray, user_id:int, tweet_id:int, freq:int);
-- aor_toks_0 = JOIN aor1hd_ids BY id, toks BY user_id;
-- aor_toks   = FOREACH aor_toks GENERATE word, user_id, tweet_id, freq ;
-- STORE aor_toks INTO 'meta/aorf/word_count/aor_toks';  

-- toks_0          = LOAD '/home/flip/ics/projects/twitter_friends/meta/aorf/word_count/aor_toks.tsv' AS (tok_word:chararray, user_id:int, tweet_id:int, freq:int);
-- toks            = FOREACH toks_0 GENERATE tok_word, user_id ;
-- toks_g_0        = GROUP toks BY (user_id, tok_word) ;
-- toks_g          = FOREACH toks_g_0 GENERATE FLATTEN(group.user_id) AS user_id, FLATTEN(group.tok_word) AS tok_word, COUNT(toks) AS freq;
-- rmf meta/aorf/word_count/aor_user_toks.tsv
-- STORE toks_g INTO 'meta/aorf/word_count/aor_user_toks.tsv' ;


user_toks_all   = LOAD '/home/flip/ics/projects/twitter_friends/meta/aorf/word_count/aor_user_toks.tsv' AS (user_id:int, word:chararray, freq:int);
user_toks       = FILTER user_toks_all BY freq > 5 ; 
user_toks_g_0   = GROUP user_toks BY user_id ;
user_toks_g_1   = FOREACH user_toks_g_0 {
  user_toks_sort = ORDER user_toks BY freq DESC;
  GENERATE group AS user_id, user_toks_sort.(word, freq);
};

aor_users  = LOAD '/home/flip/ics/projects/twitter_friends/meta/aorf/nbhd/aor1hd_users.tsv' AS (rsrc: chararray, id: int, scraped_at: long, screen_name: chararray, protected: int, followers_count: int, friends_count: int, statuses_count: int, favourites_count: int, created_at: long) ;
user_toks_id_0 = JOIN  user_toks_g_1 BY user_id, aor_users BY id;
user_toks_id = FOREACH user_toks_id_0 GENERATE id, created_at, screen_name, followers_count, friends_count, statuses_count, user_toks_sort ;
rmf /home/flip/ics/projects/twitter_friends/meta/aorf/word_count/user_toks_id.tsv ; STORE user_toks_id INTO '/home/flip/ics/projects/twitter_friends/meta/aorf/word_count/user_toks_id.tsv' ;

