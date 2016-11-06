require 'optparse'
require './lib/application'

options = { file_path: './resources/map.json', starting_room_id: 1, objects: [] }

parser = OptionParser.new do |opts|
  opts.banner = 'Usage: start.rb [options]'
  opts.on('-f', '--file file', 'File') do |file_path|
    options[:file_path] = file_path
  end

  opts.on('-r', '--room-id room-id', 'Room ID') do |rid|
    options[:starting_room_id] = rid.to_i
  end

  opts.on('-o', '--objects objects', 'Objects') do |objects|
    options[:objects] = objects.split(',')
  end

  opts.on('-h', '--help', 'Displays Help') do
    puts opts
    exit
  end
end

parser.parse!

app = Amazeingly::Application.new(
  map_file_path:    options[:file_path],
  starting_room_id: options[:starting_room_id],
  objects:          options[:objects]
)

app.start
