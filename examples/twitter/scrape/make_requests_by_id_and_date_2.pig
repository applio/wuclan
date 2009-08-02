Scrapes = LOAD 'tmp/last_requests_and_codes' AS user_id:int, rsrc:chararray, page:int, datetime:long, r200:int, r400:int, r401:int, r403:int, r404:int ;
UserScrapes = FILTER Scrapes BY rsrc == 'user' ;
UserScrapesOrdered = ORDER UserScrapes BY datetime ASC ; 
STORE UserScrapesOrdered INTO 'twmeta/scrape_requests/users_by_staleness-20090730.tsv' ;
