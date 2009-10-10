require 'ftools'

dest_config_file = File.expand_path("#{File.dirname(__FILE__)}/../../../config/onlinenic.yml")
src_config_file = "#{File.dirname(__FILE__)}/onlinenic.yml"

if File::exists? dest_config_file
  puts "\nA config file already exists at #{dest_config_file}.\n"
else
  yaml = eval "%Q[#{File.read(src_config_file)}]"
  
  File.open( dest_config_file, 'w' ) do |out|
    out.puts yaml
  end
  
  puts "\nInstalling a default configuration file."
end
