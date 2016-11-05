gem 'minitest', '~> 5.4'
require 'minitest/autorun'
require_relative '../lib/application'

class Amazeingly::ApplicationTest < Minitest::Test

  def setup
    @rooms = [
      { "id": 1, "name": "Hallway", "north": 2, "objects": [] },
      { "id": 2, "name": "Dining Room", "south": 1, "west": 3, "east": 4, "objects": []},
      { "id": 3, "name": "Kitchen","east":2, "objects": [ { "name": "Knife" } ] },
      { "id": 4, "name": "Sun Room","west":2, "objects": [ { "name": "Potted Plant" } ]}
    ]
  end

  def test_attr_accessors
    app = Amazeingly::Application.new(
      map_file_path:    './test/fixtures/map.json',
      starting_room_id: 2,
      objects:          ['Knife', 'Laptop']
    )
    assert_equal 2, app.starting_room_id
    assert_equal ['Knife', 'Laptop'], app.objects
    assert_equal Amazeingly::RoomsCollection.new(@rooms), app.rooms_collection
  end

  def test_start
    expected =  [
      "ID  Room          Object Collected",
      "----------------------------------",
      "2   Dining Room   None",
      "1   Hallway       None",
      "2   Dining Room   None",
      "4   Sun Room      Potted Plant",
      "2   Dining Room   None",
      "3   Kitchen       Knife",
      ""
    ].join("\n")

    out, err = capture_io do
      # stub file open
      app = Amazeingly::Application.new(
        map_file_path:    './test/fixtures/map.json',
        starting_room_id: 2,
        objects:          ['Knife', 'Potted Plant']
      )
      app.start
    end

    assert_equal expected, out
  end

end
