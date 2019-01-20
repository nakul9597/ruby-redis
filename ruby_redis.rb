require_relative 'lib/framework/redis_runner'
require 'yaml'

module RedisRuby

  def self.get_source
    YAML.load(File.read("config.yml"))["source_dir"]
  end

  def self.get_data_filename
    ARGV[0] ? ARGV[0] : "redis_data"
  end

  def self.server_start
    Server.run
  end

end

$source = RedisRuby.get_source
$file = RedisRuby.get_data_filename
RedisRuby.server_start