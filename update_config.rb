require 'yaml'

file_dir = { "source_dir" => Dir.pwd }
File.open("config.yml", "w") { |file| file.write(file_dir.to_yaml) }
print("Source directory #{Dir.pwd} is added to config.yml")