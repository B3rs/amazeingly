require 'minitest/autorun'
require_relative '../lib/path'
require_relative '../lib/room'

class PathTest < Minitest::Test
  def setup
    @rooms = [
      ::Room.new({ id: 1, name: "Hallway", north: 2, objects: [] }),
      ::Room.new({ id: 2, name: "Dining Room", south: 1, west: 3, east: 4, objects: []}),
      ::Room.new({ id: 3, name: "Kitchen", east:2, objects: [ { "name": "Knife" } ] }),
      ::Room.new({ id: 4, name: "Sun Room", west:2, objects: [ { "name": "Potted Plant" } ]})
    ]
    @raw_path = [
      {room: @rooms[1], collected_objects: []},
      {room: @rooms[0], collected_objects: []},
      {room: @rooms[1], collected_objects: []},
      {room: @rooms[3], collected_objects: ['Potted Plant']},
      {room: @rooms[1], collected_objects: []},
      {room: @rooms[2], collected_objects: ['Knife']}
    ]
    @room      = @rooms[2]
    @objects   = @room.object_names

  end

  def test_to_a
    expected = @raw_path
    assert_equal expected, ::Path.new(expected).to_a
    assert_equal [], ::Path.new.to_a
  end

  def test_push
    expected  = [
      {room: @room, collected_objects: @objects}
    ]
    path = ::Path.new()
    assert_equal expected, path.push(room: @room, collected_objects: @objects)
  end

  def test_visited_rooms
    assert_equal [], ::Path.new().visited_rooms
    assert_equal @rooms.sort_by{|r| r.id }, ::Path.new(@raw_path).visited_rooms.sort_by{|r| r.id }
  end

  def test_visited_room?
    path = ::Path.new(@raw_path)
    @rooms.each do |room|
      assert_equal true, path.visited_room?(room)
    end
    assert_equal false, path.visited_room?(::Room.new({ id: 5, name: "Bedroom", west:4, objects: []}))
  end

  def test_equal_operator
    expected = ::Path.new [
      {room: @rooms[1], collected_objects: []},
      {room: @rooms[0], collected_objects: []},
      {room: @rooms[1], collected_objects: []},
      {room: @rooms[3], collected_objects: ['Potted Plant']},
      {room: @rooms[1], collected_objects: []},
      {room: @rooms[2], collected_objects: ['Knife']}
    ]
    assert_equal expected, ::Path.new(@raw_path)
    expected = ::Path.new [
      {room: @rooms[1], collected_objects: []},
      {room: @rooms[0], collected_objects: []},
      {room: @rooms[3], collected_objects: ['Potted Plant']},
      {room: @rooms[1], collected_objects: []},
      {room: @rooms[2], collected_objects: ['Knife']}
    ]
    refute_equal expected, ::Path.new(@raw_path)
  end

end
