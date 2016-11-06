gem 'minitest', '~> 5.4'
require 'minitest/autorun'
require_relative '../lib/room'

class Amazeingly::RoomTest < Minitest::Test
  def setup
    @room = Amazeingly::Room.new(id: 4, name: 'Sun Room', west: 2, south: 1, objects: [{ name: 'Fork' }, { name: 'Potted Plant' }])
  end

  def test_attr_reader
    assert_equal 4, @room.id
    assert_equal 'Sun Room', @room.name
    assert_equal nil, @room.north
    assert_equal 1, @room.south
    assert_equal nil, @room.east
    assert_equal 2, @room.west
    assert_equal [{ name: 'Fork' }, { name: 'Potted Plant' }], @room.objects
  end

  def test_has_object?
    assert_equal false, @room.has_object?('Knife')
    assert_equal true, @room.has_object?('Potted Plant')
  end

  def test_has_objects?
    assert_equal true, @room.has_objects?(['Potted Plant'])
    assert_equal true, @room.has_objects?(['Potted Plant', 'Fork'])
    assert_equal true, @room.has_objects?(['Fork'])
    assert_equal false, @room.has_objects?(['Knife'])
  end

  def test_matching_objects
    assert_equal ['Fork'], @room.matching_objects(%w(Fork Knife))
    assert_equal ['Potted Plant', 'Fork'], @room.matching_objects(['Potted Plant', 'Fork'])
    assert_equal [], @room.matching_objects(%w(Knife Laptop))
  end

  def test_object_names
    assert_equal ['Fork', 'Potted Plant'], @room.object_names
  end

  def test_connected_room_ids
    assert_equal [1, 2], @room.connected_room_ids
  end

  def test_equal_operator
    expected = Amazeingly::Room.new id: 4, name: 'Sun Room', west: 2, south: 1, objects: [{ name: 'Fork' }, { name: 'Potted Plant' }]
    assert_equal expected, @room
    expected = Amazeingly::Room.new id: 3, name: 'Sun Room', west: 2, south: 1, objects: [{ name: 'Fork' }, { name: 'Potted Plant' }]
    refute_equal expected, @room
  end
end
