require 'json'

class Database

  def self.read
    begin
      file = File.read("#{$source}/resource/#{$file}.json")
      $data = JSON.parse(file)
    rescue StandardError => e
      return Status.new(1001)
    end
    return Status.new(200)
  end

  def self.write
    begin
      File.open("#{$source}/resource/#{$file}.json","w"){ |f| f << $data.to_json }
    rescue StandardError => e
    	return Status.new(1001)
    end
    return Status.new(200)
  end

end
