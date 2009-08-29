script_dir=`dirname $0`
ttserver -port 10022 $script_dir/rawd/distdb/twitter_api-`hostname`.tch >> $script_dir/rawd/log/twitter_api-ttserver-`datename`.log 2>&1
