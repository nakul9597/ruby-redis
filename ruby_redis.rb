require_relative 'lib/framework/app_runner'

$source = YAML.load(File.read(Dir.pwd+"/config.yml"))["source_dir"]
$file = (ARGV[0] ? ARGV[0] : "redis_data")
App.run