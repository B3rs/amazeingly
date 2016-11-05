gem 'minitest', '~> 5.4'
require 'minitest/autorun'
require_relative '../lib/path_finder'
require_relative '../lib/rooms_collection'
require_relative '../lib/room'

class Amazeingly::PathFinderTest < Minitest::Test
  def setup
    @rooms = [
      { id: 1, name: "Hallway", north: 2, objects: [] },
      { id: 2, name: "Dining Room", south: 1, west: 3, east: 4, objects: []},
      { id: 3, name: "Kitchen", east:2, objects: [ { "name": "Knife" } ] },
      { id: 4, name: "Sun Room", west:2, objects: [ { "name": "Potted Plant" } ]}
    ]
    @rooms_collection = Amazeingly::RoomsCollection.new(@rooms)
    @path_finder = Amazeingly::PathFinder.new(rooms_collection: @rooms_collection, starting_room_id: 3, objects: ['Knife'])
  end

  def test_attr_reader
    assert_equal @rooms_collection, @path_finder.rooms_collection
  end

  # search is very important so i put every single test in a method for better isolation
  def test_simple_find
    path_finder = Amazeingly::PathFinder.new(
      rooms_collection: @rooms_collection,
      starting_room_id: 3,
      objects:          ['Knife']
    )
    expected = Amazeingly::Path.new([
      {room: Amazeingly::Room.new(@rooms[2]), collected_objects: ['Knife']}
    ])

    assert_equal expected, path_finder.path_for_objects
  end

  def test_short_find
    path_finder = Amazeingly::PathFinder.new(
      rooms_collection: @rooms_collection,
      starting_room_id: 2,
      objects:          ['Potted Plant']
    )
    expected = Amazeingly::Path.new([
      {room: Amazeingly::Room.new(@rooms[1]), collected_objects: []},
      {room: Amazeingly::Room.new(@rooms[0]), collected_objects: []},
      {room: Amazeingly::Room.new(@rooms[1]), collected_objects: []},
      {room: Amazeingly::Room.new(@rooms[3]), collected_objects: ['Potted Plant']}
    ])

    assert_equal expected, path_finder.path_for_objects
  end

  def test_another_short_find
    path_finder = Amazeingly::PathFinder.new(
      rooms_collection: @rooms_collection,
      starting_room_id: 2,
      objects:          ['Knife']
    )
    expected = Amazeingly::Path.new([
      {room: Amazeingly::Room.new(@rooms[1]), collected_objects: []},
      {room: Amazeingly::Room.new(@rooms[0]), collected_objects: []},
      {room: Amazeingly::Room.new(@rooms[1]), collected_objects: []},
      {room: Amazeingly::Room.new(@rooms[3]), collected_objects: []},
      {room: Amazeingly::Room.new(@rooms[1]), collected_objects: []},
      {room: Amazeingly::Room.new(@rooms[2]), collected_objects: ['Knife']}
    ])

    assert_equal expected, path_finder.path_for_objects
  end

  def test_complete_path_for_objects
    path_finder = Amazeingly::PathFinder.new(
      rooms_collection: @rooms_collection,
      starting_room_id: 2,
      objects:          ['Knife', 'Potted Plant']
    )
    expected = Amazeingly::Path.new([
      {room: Amazeingly::Room.new(@rooms[1]), collected_objects: []},
      {room: Amazeingly::Room.new(@rooms[0]), collected_objects: []},
      {room: Amazeingly::Room.new(@rooms[1]), collected_objects: []},
      {room: Amazeingly::Room.new(@rooms[3]), collected_objects: ['Potted Plant']},
      {room: Amazeingly::Room.new(@rooms[1]), collected_objects: []},
      {room: Amazeingly::Room.new(@rooms[2]), collected_objects: ['Knife']}
    ])

    assert_equal expected, path_finder.path_for_objects
  end

  def test_impossible_path_for_objects
    path_finder = Amazeingly::PathFinder.new(
        rooms_collection: @rooms_collection,
        starting_room_id: 2,
        objects:          ['Laptop', 'Potted Plant']
    )

    assert_equal nil, path_finder.path_for_objects
  end

end
