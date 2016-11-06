require './lib/path'
module Amazeingly
  class PathFinder
    attr_reader :rooms_collection

    def initialize(rooms_collection:)
      @rooms_collection = rooms_collection
    end

    def path_for(objects: [], starting_room_id:)
      from_room       = rooms_collection.find(starting_room_id)
      search_objects  = objects.clone

      # Use a reduce function to calculate and merge paths between the starting room and the first object,
      # the first object and the second object, the second object and the third object... (and so on)
      # If i find some objects by the road i collect them and remove them from the queue
      Amazeingly::Path.new.tap do |path|
        while search_objects.any?
          object  = search_objects.first
          to_room = rooms_collection.room_for(object: object)
          s_path  = shortest_path(from_room: from_room, to_room: to_room, objects: search_objects)
          return nil unless s_path

          path.merge! s_path
          from_room = to_room
          search_objects -= path.collected_objects
        end
      end

      # objects.reduce() do |path, object|
      #   to_room = rooms_collection.room_for(object: object)
      #   path.tap do |path|
      #     short_path = shortest_path(from_room: from_room, to_room: to_room, objects: objects)
      #     return nil if !short_path
      #     path.merge! short_path
      #     from_room = to_room
      #   end
      # end
    end

    def shortest_path(from_room:, to_room:, objects: [])
      # A depth first search of rooms tree where the root is the from_room parameter
      matching_objects = from_room.matching_objects(objects)
      search_objects  = objects.clone - matching_objects
      paths_queue     = [Amazeingly::Path.new([{ room: from_room, collected_objects: matching_objects }])]
      valid_paths     = []

      while paths_queue.any?
        # I get the first path in the queue
        path = paths_queue.shift
        # I check if the last room in this path is the destination room and,
        # eventually, add it to the valid paths
        room = path.last_visited_room
        valid_paths << path if room == to_room

        # For each connected room i create some paths starting from current path (path)
        # and adding connected - already visited rooms
        next_rooms = rooms_collection.connected_rooms(room) - path.visited_rooms
        next unless next_rooms.any?
        next_rooms.each do |next_room|
          new_path = Amazeingly::Path.new(path.steps)
          matching_objects = next_room.matching_objects(objects)
          search_objects -= matching_objects
          new_path.push(room: next_room, collected_objects: matching_objects)
          paths_queue << new_path
        end
      end

      # Search for and return the shortest path
      valid_paths.sort_by { |path| path.steps.count }.first
    end
  end
end
