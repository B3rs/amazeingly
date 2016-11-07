require 'minitest/autorun'
require_relative '../lib/path'
require_relative '../lib/room'

class Amazeingly::PathTest < Minitest::Test
  def setup
    @rooms = [
      Amazeingly::Room.new(id: 1, name: 'Hallway', north: 2, objects: []),
      Amazeingly::Room.new(id: 2, name: 'Dining Room', south: 1, west: 3, east: 4, objects: []),
      Amazeingly::Room.new(id: 3, name: 'Kitchen', east: 2, objects: [{ name: 'Knife' }]),
      Amazeingly::Room.new(id: 4, name: 'Sun Room', west: 2, objects: [{ name: 'Potted Plant' }])
    ]
    @raw_path = [
      { room: @rooms[1], collected_objects: [] },
      { room: @rooms[0], collected_objects: [] },
      { room: @rooms[1], collected_objects: [] },
      { room: @rooms[3], collected_objects: ['Potted Plant'] },
      { room: @rooms[1], collected_objects: [] },
      { room: @rooms[2], collected_objects: ['Knife'] }
    ]
    @steps = @raw_path.map.with_index { |step, i| step.merge(step_number: i + 1) }
    @room = @rooms[2]
    @objects = @room.object_names
  end

  def test_steps
    expected = @steps
    assert_equal expected, Amazeingly::Path.new(@raw_path).steps
    assert_equal [], Amazeingly::Path.new.steps
  end

  def test_push
    expected = [{ step_number: 1, room: @room, collected_objects: @objects }]
    assert_equal expected, Amazeingly::Path.new.push(room: @room, collected_objects: @objects)
    expected = [{ step_number: 1, room: @room, collected_objects: [] }]
    assert_equal expected, Amazeingly::Path.new.push(room: @room)
  end

  def test_last_visited_room
    assert_equal @rooms[2], Amazeingly::Path.new(@raw_path).last_visited_room
    assert_equal nil, Amazeingly::Path.new.last_visited_room
  end

  def test_visited_rooms
    assert_equal [], Amazeingly::Path.new.visited_rooms
    assert_equal @rooms.sort_by(&:id), Amazeingly::Path.new(@raw_path).visited_rooms.sort_by(&:id)
  end

  def test_merge!
    expected = Amazeingly::Path.new [
      { room: @rooms[0], collected_objects: [] },
      { room: @rooms[1], collected_objects: [] },
      { room: @rooms[3], collected_objects: ['Potted Plant'] },
      { room: @rooms[1], collected_objects: [] }
    ]
    steps1 = [
      { room: @rooms[0], collected_objects: [] },
      { room: @rooms[1], collected_objects: [] },
      { room: @rooms[3], collected_objects: ['Potted Plant'] }
    ]
    steps2 = [
      { room: @rooms[3], collected_objects: [] },
      { room: @rooms[1], collected_objects: [] }
    ]
    assert_equal expected, Amazeingly::Path.new(steps1).merge!(Amazeingly::Path.new(steps2))

    expected = Amazeingly::Path.new [
      { room: @rooms[0], collected_objects: [] },
      { room: @rooms[1], collected_objects: [] },
      { room: @rooms[3], collected_objects: [] },
      { room: @rooms[1], collected_objects: [] }
    ]
    steps1 = [
      { room: @rooms[0], collected_objects: [] },
      { room: @rooms[1], collected_objects: [] }
    ]
    steps2 = [
      { room: @rooms[3], collected_objects: [] },
      { room: @rooms[1], collected_objects: [] }
    ]
    assert_equal expected, Amazeingly::Path.new(steps1).merge!(Amazeingly::Path.new(steps2))
  end

  def test_collected_objects
    path = Amazeingly::Path.new [
      { room: @rooms[1], collected_objects: [] },
      { room: @rooms[0], collected_objects: [] },
      { room: @rooms[1], collected_objects: [] },
      { room: @rooms[3], collected_objects: ['Potted Plant'] },
      { room: @rooms[1], collected_objects: [] },
      { room: @rooms[2], collected_objects: ['Knife'] }
    ]
    assert_equal ['Potted Plant', 'Knife'], path.collected_objects
  end

  def test_equal_operator
    expected = Amazeingly::Path.new [
      { room: @rooms[1], collected_objects: [] },
      { room: @rooms[0], collected_objects: [] },
      { room: @rooms[1], collected_objects: [] },
      { room: @rooms[3], collected_objects: ['Potted Plant'] },
      { room: @rooms[1], collected_objects: [] },
      { room: @rooms[2], collected_objects: ['Knife'] }
    ]
    assert_equal expected, Amazeingly::Path.new(@raw_path)
    expected = Amazeingly::Path.new [
      { room: @rooms[1], collected_objects: [] },
      { room: @rooms[0], collected_objects: [] },
      { room: @rooms[3], collected_objects: ['Potted Plant'] },
      { room: @rooms[1], collected_objects: [] },
      { room: @rooms[2], collected_objects: ['Knife'] }
    ]
    refute_equal expected, Amazeingly::Path.new(@raw_path)
  end
end
