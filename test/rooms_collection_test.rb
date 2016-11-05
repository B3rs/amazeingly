gem 'minitest', '~> 5.4'
require 'minitest/autorun'
require_relative '../lib/rooms_collection'

class RoomsCollectionTest < Minitest::Test
  def setup
    @rooms = [
      ::Room.new({ id: 1, name: "Hallway", north: 2, objects: [] }),
      ::Room.new({ id: 2, name: "Dining Room", south: 1, west: 3, east: 4, objects: []}),
      ::Room.new({ id: 3, name: "Kitchen", east:2, objects: [ { "name": "Knife" } ] }),
      ::Room.new({ id: 4, name: "Sun Room", west:2, objects: [ { "name": "Potted Plant" } ]})
    ]
    @rooms_collection = ::RoomsCollection.new(@rooms)
  end

  def test_attr_reader
    assert_equal @rooms, @rooms_collection.rooms
  end

  def test_find
    assert_equal 1, @rooms_collection.find(1).id
    assert_equal 4, @rooms_collection.find(4).id
    assert_equal nil, @rooms_collection.find(5)
  end

  def test_count
    assert_equal @rooms.count, @rooms_collection.count
    assert_equal 0, ::RoomsCollection.new.count
  end

  def test_connected_rooms
    assert_equal [@rooms[1]], @rooms_collection.connected_rooms(@rooms[2])
    assert_equal [@rooms[0], @rooms[3], @rooms[2]], @rooms_collection.connected_rooms(@rooms[1])
  end

end
