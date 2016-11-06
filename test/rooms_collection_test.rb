gem 'minitest', '~> 5.4'
require 'minitest/autorun'
require_relative '../lib/rooms_collection'

class Amazeingly::RoomsCollectionTest < Minitest::Test
  def setup
    @rooms = [
      { id: 1, name: 'Hallway', north: 2, objects: [] },
      { id: 2, name: 'Dining Room', south: 1, west: 3, east: 4, objects: [] },
      { id: 3, name: 'Kitchen', east: 2, objects: [{ name: 'Knife' }] },
      { id: 4, name: 'Sun Room', west: 2, objects: [{ name: 'Potted Plant' }] }
    ]
    @rooms_collection = Amazeingly::RoomsCollection.new(@rooms)
  end

  def test_attr_reader
    expected = @rooms.map { |room| Amazeingly::Room.new(room) }
    assert_equal expected, @rooms_collection.rooms
  end

  def test_find
    assert_equal 1, @rooms_collection.find(1).id
    assert_equal 4, @rooms_collection.find(4).id
    assert_equal nil, @rooms_collection.find(5)
  end

  def test_count
    assert_equal @rooms.count, @rooms_collection.count
    assert_equal 0, Amazeingly::RoomsCollection.new.count
  end

  def test_room_for
    assert_equal Amazeingly::Room.new(@rooms[2]), @rooms_collection.room_for(object: 'Knife')
    assert_equal nil, @rooms_collection.room_for(object: 'Laptop')
  end

  def test_connected_rooms
    expected = [
      Amazeingly::Room.new(@rooms[1])
    ]
    assert_equal expected, @rooms_collection.connected_rooms(Amazeingly::Room.new(@rooms[2]))
    expected = [
      Amazeingly::Room.new(@rooms[0]),
      Amazeingly::Room.new(@rooms[3]),
      Amazeingly::Room.new(@rooms[2])
    ]
    assert_equal expected, @rooms_collection.connected_rooms(Amazeingly::Room.new(@rooms[1]))
  end

  def test_equal_operator
    assert_equal Amazeingly::RoomsCollection.new(@rooms), @rooms_collection
    refute_equal Amazeingly::RoomsCollection.new(@rooms), Amazeingly::RoomsCollection.new(@rooms - [@rooms.first])
  end
end
