gem 'minitest', '~> 5.4'
require 'minitest/autorun'
require_relative '../lib/rooms_collection'

class RoomsCollectionTest < Minitest::Test
  def setup
    @rooms = [
      ::Room.new({ id: 4, name: "Sun Room", west:2, objects: [ { "name": "Potted Plant" } ]}),
      ::Room.new({ id: 1, name: "Hallway", north: 2, objects: [] })
    ]
  end

  def test_attr_reader
    assert_equal @rooms, ::RoomsCollection.new(@rooms).rooms
  end

  def test_find
    rooms_collection = ::RoomsCollection.new(@rooms)
    assert_equal 1, rooms_collection.find(1).id
    assert_equal 4, rooms_collection.find(4).id
    assert_equal nil, rooms_collection.find(5)
  end
end
