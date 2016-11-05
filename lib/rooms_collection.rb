require './lib/room'
require './lib/path'

class RoomsCollection

  attr_reader :rooms

  def initialize(rooms=[])
    @rooms = rooms
  end

  def find(id)
    rooms.detect { |room| room.id == id }
  end

  def connected_rooms(room)
    room.connected_room_ids.map{ |id| find(id) }
  end

  def count
    rooms.count
  end


end
