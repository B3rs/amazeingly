require './lib/room'
require './lib/path'
require './lib/exceptions'

module Amazeingly
  class RoomsCollection
    attr_reader :rooms

    def initialize(rooms = [])
      @rooms = []
      rooms.each { |room| push(room) }
    end

    def push(room)
      raise RoomsCollectionException, "Duplicate Room with ID: #{room[:id]}" if find(room[:id])
      rooms << Amazeingly::Room.new(room)
    end

    def find(id)
      rooms.find { |room| room.id == id }
    end

    def connected_rooms(room)
      room.connected_room_ids.map { |id| find(id) }
    end

    def room_for(object:)
      rooms.find { |room| room.objects.include?(name: object) }
    end

    def ==(collection)
      rooms.sort_by(&:id) == collection.rooms.sort_by(&:id)
    end
  end
end
