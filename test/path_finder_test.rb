gem 'minitest', '~> 5.4'
require 'minitest/autorun'
require 'json'
require 'amazeingly/path_finder'
require 'amazeingly/room'
require 'amazeingly/rooms_collection'

class Amazeingly::PathFinderTest < Minitest::Test
  def setup
    @rooms = JSON.parse(File.read('./test/fixtures/map.json'), symbolize_names: true)[:rooms]
    @rooms_collection = Amazeingly::RoomsCollection.new(@rooms)
    @path_finder = Amazeingly::PathFinder.new(rooms_collection: @rooms_collection)
  end

  def test_attr_reader
    assert_equal @rooms_collection, @path_finder.rooms_collection
  end

  def test_valid_paths
    paths = @path_finder.valid_paths(from_room: @rooms_collection.find(6), to_room: @rooms_collection.find(4))
    expected = [
      Amazeingly::Path.new([
                             { step_number: 1, room: @rooms_collection.find(6), collected_objects: [] },
                             { step_number: 2, room: @rooms_collection.find(5), collected_objects: [] },
                             { step_number: 3, room: @rooms_collection.find(7), collected_objects: [] },
                             { step_number: 4, room: @rooms_collection.find(4), collected_objects: [] }
                           ]),
      Amazeingly::Path.new([
                             { step_number: 1, room: @rooms_collection.find(6), collected_objects: [] },
                             { step_number: 2, room: @rooms_collection.find(5), collected_objects: [] },
                             { step_number: 3, room: @rooms_collection.find(1), collected_objects: [] },
                             { step_number: 4, room: @rooms_collection.find(2), collected_objects: [] },
                             { step_number: 5, room: @rooms_collection.find(4), collected_objects: [] }
                           ])
    ]

    assert_equal expected, paths

    steps = @path_finder.shortest_path(from_room: @rooms_collection.find(1), to_room: @rooms_collection.find(3))
    expected = Amazeingly::Path.new [
      { step_number: 1, room: @rooms_collection.find(1), collected_objects: [] },
      { step_number: 2, room: @rooms_collection.find(2), collected_objects: [] },
      { step_number: 3, room: @rooms_collection.find(3), collected_objects: [] }
    ]
    assert_equal expected, steps

    steps = @path_finder.shortest_path(from_room: @rooms_collection.find(1), to_room: @rooms_collection.find(4))
    expected = Amazeingly::Path.new [
      { step_number: 1, room: @rooms_collection.find(1), collected_objects: [] },
      { step_number: 2, room: @rooms_collection.find(2), collected_objects: [] },
      { step_number: 3, room: @rooms_collection.find(4), collected_objects: [] }
    ]
    assert_equal expected, steps

    steps = @path_finder.shortest_path(from_room: @rooms_collection.find(3), to_room: @rooms_collection.find(5))
    expected = Amazeingly::Path.new [
      { step_number: 1, room: @rooms_collection.find(3), collected_objects: [] },
      { step_number: 2, room: @rooms_collection.find(2), collected_objects: [] },
      { step_number: 3, room: @rooms_collection.find(1), collected_objects: [] },
      { step_number: 4, room: @rooms_collection.find(5), collected_objects: [] }
    ]
    assert_equal expected, steps
  end

  # Test shortest path with different contexts
  def test_shortest_path
    expected = Amazeingly::Path.new([
                                      { step_number: 1, room: @rooms_collection.find(6), collected_objects: [] },
                                      { step_number: 2, room: @rooms_collection.find(5), collected_objects: [] },
                                      { step_number: 3, room: @rooms_collection.find(7), collected_objects: [] },
                                      { step_number: 4, room: @rooms_collection.find(4), collected_objects: [] }
                                    ])

    assert_equal expected, @path_finder.shortest_path(from_room: @rooms_collection.find(6), to_room: @rooms_collection.find(4))
  end

  # from now on i test path_for objects in different contexts
  def test_simple_path_for
    path_finder = Amazeingly::PathFinder.new(rooms_collection: @rooms_collection)
    expected = Amazeingly::Path.new([
                                      { room: Amazeingly::Room.new(@rooms[2]), collected_objects: ['Knife'] }
                                    ])

    assert_equal expected, path_finder.path_for(objects: ['Knife'], starting_room_id: 3)
  end

  def test_short_path_for
    path_finder = Amazeingly::PathFinder.new(rooms_collection: @rooms_collection)
    expected = Amazeingly::Path.new([
                                      { room: Amazeingly::Room.new(@rooms[1]), collected_objects: [] },
                                      { room: Amazeingly::Room.new(@rooms[3]), collected_objects: ['Potted Plant'] }
                                    ])

    assert_equal expected, path_finder.path_for(objects: ['Potted Plant'], starting_room_id: 2)
  end

  def test_another_short_path_for
    path_finder = Amazeingly::PathFinder.new(rooms_collection: @rooms_collection)
    expected = Amazeingly::Path.new([
                                      { room: Amazeingly::Room.new(@rooms[1]), collected_objects: [] },
                                      { room: Amazeingly::Room.new(@rooms[2]), collected_objects: ['Knife'] }
                                    ])

    assert_equal expected, path_finder.path_for(objects: ['Knife'], starting_room_id: 2)
  end

  def test_complete_path_for
    path_finder = Amazeingly::PathFinder.new(rooms_collection: @rooms_collection)
    expected = Amazeingly::Path.new([
                                      { room: Amazeingly::Room.new(@rooms[1]), collected_objects: [] },
                                      { room: Amazeingly::Room.new(@rooms[2]), collected_objects: ['Knife'] },
                                      { room: Amazeingly::Room.new(@rooms[1]), collected_objects: [] },
                                      { room: Amazeingly::Room.new(@rooms[3]), collected_objects: ['Potted Plant'] },
                                      { room: Amazeingly::Room.new(@rooms[6]), collected_objects: ['Laptop'] }
                                    ])

    assert_equal expected, path_finder.path_for(objects: ['Knife', 'Laptop', 'Potted Plant'], starting_room_id: 2)
  end

  def test_cyclic_path_for
    path_finder = Amazeingly::PathFinder.new(rooms_collection: @rooms_collection)
    expected = Amazeingly::Path.new([
                                      { room: Amazeingly::Room.new(@rooms[0]), collected_objects: [] },
                                      { room: Amazeingly::Room.new(@rooms[4]), collected_objects: [] },
                                      { room: Amazeingly::Room.new(@rooms[6]), collected_objects: ['Laptop'] },
                                      { room: Amazeingly::Room.new(@rooms[3]), collected_objects: [] },
                                      { room: Amazeingly::Room.new(@rooms[1]), collected_objects: [] },
                                      { room: Amazeingly::Room.new(@rooms[2]), collected_objects: ['Knife'] }
                                    ])
    assert_equal expected, path_finder.path_for(objects: %w(Laptop Knife), starting_room_id: 1)
  end

  def test_impossible_path_for
    path_finder = Amazeingly::PathFinder.new(rooms_collection: @rooms_collection)

    assert_equal nil, path_finder.path_for(objects: ['Fork', 'Potted Plant'], starting_room_id: 2)
    assert_equal nil, path_finder.path_for(objects: ['Potted Plant', 'Fork'], starting_room_id: 2)
    assert_equal Amazeingly::Path.new, path_finder.path_for(objects: [], starting_room_id: 2)
  end
end
