$: << File.dirname(__FILE__)+'/../../../../edamame/lib'
require 'edamame/monitoring'
WORK_DIR = File.dirname(__FILE__)+'/work'

#
# For debugging:
#
#   sudo god -c this_file.god -D
#
# (for production, use the etc/initc.d script in this directory)
#
# TODO: define an EdamameDirector that lets us name these collections.
#
THE_FAITHFUL = [
  # twitter_search
  [BeanstalkdGod, { :port => 11240, :max_mem_usage => 100.megabytes,  }],
  [TyrantGod,     { :port => 11241, :db_dirname => WORK_DIR, :db_name => "twitter_search-queue.tct" }],
  #
  # [TyrantGod,     { :port => 11249, :db_dirname => WORK_DIR, :db_name => "twitter_search-flat.tct" }],
]

THE_FAITHFUL.each do |klass, config|
  proc = klass.create(config.merge :flapping_notify => 'default')
  proc.mkdirs!
end
