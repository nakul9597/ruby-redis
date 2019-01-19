require 'json'
require 'yaml'

class Database
	
  def self.read
    file = File.read("#{$source}/resource/#{$file}.json")
    $data = JSON.parse(file)
  end

  def self.write
    File.open("#{$source}/resource/#{$file}.json","w"){ |f| f << $data.to_json }
  end

end
