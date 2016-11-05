require './lib/path'
class PathFinder

  attr_reader :rooms_collection, :starting_room, :objects

  def initialize(args)
    @rooms_collection = args[:rooms_collection]
    @starting_room    = @rooms_collection.find(args[:starting_room_id])
    @objects    = args[:objects]
  end

  def path_for_objects
    path           = ::Path.new()
    rooms_queue    = [ starting_room ]
    current_room   = rooms_queue.first
    target_objects = objects

    loop do
      previous_room   = current_room
      current_room    = rooms_queue.shift
      found_objects   = current_room.matching_objects(target_objects)
      target_objects  = target_objects - found_objects
      path.push(room: current_room, collected_objects: found_objects)


      return path if target_objects.empty?
      return nil if path.visited_rooms.count == rooms_collection.count

      next_rooms = rooms_collection.connected_rooms(current_room) - path.visited_rooms

      if next_rooms.any?
        rooms_queue = next_rooms + rooms_queue
      else
        # I can't go in any unvisited rooms, revert last step and go back to previous room
        rooms_queue = rooms_queue.unshift(previous_room)
      end
    end
  end

end
