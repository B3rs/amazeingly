gem 'minitest', '~> 5.4'
require 'minitest/autorun'
require_relative '../lib/application'

class Amazeingly::ApplicationTest < Minitest::Test
  def setup
    @rooms = JSON.parse(File.read('./test/fixtures/map.json'), symbolize_names: true)[:rooms]
  end

  def test_attr_accessors
    app = Amazeingly::Application.new(
      map_file_path: './test/fixtures/map.json',
      starting_room_id: 2,
      objects: %w(Knife Laptop)
    )
    assert_equal 2, app.starting_room_id
    assert_equal %w(Knife Laptop), app.objects
    assert_equal Amazeingly::RoomsCollection.new(@rooms), app.rooms_collection
  end

  def test_start
    expected = [
      'ID  Room          Object Collected',
      '----------------------------------',
      '2   Dining Room   None',
      '3   Kitchen       Knife',
      '2   Dining Room   None',
      '4   Sun Room      Potted Plant',
      ''
    ].join("\n")

    out, err = capture_io do
      # stub file open
      app = Amazeingly::Application.new(
        map_file_path: './test/fixtures/map.json',
        starting_room_id: 2,
        objects: ['Knife', 'Potted Plant']
      )
      app.start
    end

    assert_equal expected, out
  end
end
