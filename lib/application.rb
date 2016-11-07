require 'json'
require './lib/rooms_collection'
require './lib/path_finder'
require './lib/exceptions'

module Amazeingly
  class Application
    def initialize(map_file_path:, starting_room_id:, objects:)
      @file_path        = map_file_path
      @starting_room_id = starting_room_id
      @objects          = objects
    end

    def start
      rooms_collection = read_file(file_path)
      raise InputException, 'Invalid starting Room ID' unless rooms_collection.find(starting_room_id)
      path = search_path(rooms_collection)

      print(path)
    rescue InputException => e
      puts e.message
    rescue Errno::ENOENT => e
      puts 'Cannot read the specified input file'
    end

    private

    attr_accessor :file_path, :starting_room_id, :objects

    def read_file(file_path)
      json_file = JSON.parse File.read(file_path), symbolize_names: true
      create_rooms_collection(json_file[:rooms])
    end

    def create_rooms_collection(rooms)
      Amazeingly::RoomsCollection.new(rooms)
    end

    def search_path(rooms_collection)
      path_finder = Amazeingly::PathFinder.new(rooms_collection: rooms_collection)
      path_finder.path_for(objects: objects, starting_room_id: starting_room_id)
    end

    def print(path)
      if path
        header      = 'ID  Room          Object Collected'
        separator   = '----------------------------------'
        rows = path.steps.map do |step|
          step[:room].id.to_s.ljust(4) +
            step[:room].name.ljust(14) +
            (step[:collected_objects].any? ? step[:collected_objects].join(' ') : 'None')
        end

        puts [header, separator, rows].join("\n")
      else
        puts 'It\'s impossible to find a valid path for these objects'
      end
    end
  end
end
