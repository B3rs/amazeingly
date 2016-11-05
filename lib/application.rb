require 'json'
require './lib/rooms_collection'
require './lib/path_finder'

module Amazeingly
  class Application
    attr_accessor :rooms_collection, :starting_room_id, :objects

    def initialize(map_file_path:, starting_room_id:, objects:)
      json_file = JSON.parse File.read(map_file_path), symbolize_names: true
      @rooms_collection = Amazeingly::RoomsCollection.new(json_file[:rooms])
      @starting_room_id = starting_room_id
      @objects          = objects
    end

    def start
      path_finder = Amazeingly::PathFinder.new(rooms_collection: rooms_collection, starting_room_id: starting_room_id, objects: objects)
      path = path_finder.path_for_objects

      print_path(path)
    end

    private

    def print_path(path)
      header      = 'ID  Room          Object Collected'
      separator   = '----------------------------------'
      rows = path.to_a.map do |step|
        step[:room].id.to_s.ljust(4) +
          step[:room].name.ljust(14) +
          (step[:collected_objects].any? ? step[:collected_objects].join(' ') : 'None')
      end

      puts [header, separator, rows].join("\n")
    end
  end
end
