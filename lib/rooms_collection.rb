require './lib/room'

class RoomsCollection
  
  attr_reader :rooms
  def initialize(rooms)
    @rooms = rooms
  end

  def find(id)
    @rooms.detect { |room| room.id == id }
  end
end
