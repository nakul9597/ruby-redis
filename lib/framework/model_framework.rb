require 'json'
require_relative '../application/source'

class Database

  def self.read
    file = File.read("#{source}/resource/redis_data.json")
    $data = JSON.parse(file)
  end

  def self.write
    File.open("#{source}/resource/redis_data.json","w"){ |f| f << $data.to_json }
  end

end
