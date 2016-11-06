require 'optparse'
require './lib/application'

options = {file_path: './resources/map.json', starting_room_id: 1, objects: []}

parser = OptionParser.new do|opts|
  opts.banner = "Usage: years.rb [options]"
  opts.on('-n', '--name name', 'Name') do |name|
    options[:name] = name;
  end

  opts.on('-a', '--age age', 'Age') do |age|
    options[:age] = age;
  end

  opts.on('-h', '--help', 'Displays Help') do
    puts opts
    exit
  end
end

parser.parse!

app = Amazeingly::Application.new(
  map_file_path: ARGV[0],
  starting_room_id: ARGV[1].to_i,
  objects: ARGV[2].split(',')
)
app.start
