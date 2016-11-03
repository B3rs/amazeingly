gem 'minitest', '~> 5.4'
require 'minitest/autorun'
require_relative '../lib/room'

class RoomTest < Minitest::Test
  def test_attr_reader
    room = ::Room.new({ id: 4, name: "Sun Room", west:2, objects: [ { "name": "Potted Plant" } ]})
    assert_equal 4, room.id
    assert_equal 'Sun Room', room.name
    assert_equal [], room.north
    assert_equal [], room.south
    assert_equal [], room.east
    assert_equal 2, room.west
    assert_equal [{ "name": "Potted Plant" }], room.objects
  end
end
