require './lib/room'
require './lib/path'

module Amazeingly
  class RoomsCollection

    attr_reader :rooms

    def initialize(rooms=[])
      @rooms = rooms.map{|room| Amazeingly::Room.new(room)}
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

    def ==(collection)
      rooms.sort_by{|room| room.id} == collection.rooms.sort_by{|room| room.id}
    end

  end
end
