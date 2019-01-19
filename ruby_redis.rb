require_relative 'lib/framework/app_runner'

$file = (ARGV[0] ? ARGV[0] : "redis_data")
App.run