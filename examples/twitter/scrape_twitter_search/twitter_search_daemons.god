require 'edamame/monitoring'
EDAMAME_DB_DIR = '/data/distdb' unless defined?(EDAMAME_DB_DIR)

#
# For debugging:
#
#   sudo god -c /Users/flip/ics/edamame/utils/god/edamame.god -D
#
# (for production, use the etc/initc.d script in this directory)
#
# TODO: define an EdamameDirector that lets us name these collections.
#
THE_FAITHFUL = [
  [BeanstalkdGod, { :port => 11210, :max_mem_usage => 2.gigabytes,  }],
  [TyrantGod,     { :port => 11212, :db_dirname => EDAMAME_DB_DIR, :db_name => 'flat_delay_queue.tct' }],
  [TyrantGod,     { :port => 11213, :db_dirname => EDAMAME_DB_DIR, :db_name => 'fetched_urls.tch' }],
  # [SinatraGod,    { :port => 11219, :app_dirname => File.dirname(__FILE__)+'/../../app/edamame_san' }],
]

THE_FAITHFUL.each do |klass, config|
  proc = klass.create(config.merge :flapping_notify => 'default')
  proc.mkdirs!
end
