require './lib/application'

app = Amazeingly::Application.new(
  map_file_path: ARGV[0],
  starting_room_id: ARGV[1].to_i,
  objects: ARGV[2].split(',')
)
app.start
