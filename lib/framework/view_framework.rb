require_relative '../application/source'
require_relative '../application/html_converter'
class FileRead
  
  def self.html(file_name)
    begin
    IO.read("#{source}/application/#{file_name}.html")
    rescue Errno::ENOENT
      return false
    end
  end

  def self.psql(data)
    [to_html(data),200]
  end

end
