gem 'minitest', '~> 5.4'
require 'minitest/autorun'
require_relative '../lib/application'

class Amazeingly::ApplicationTest < Minitest::Test
  def setup
    @rooms = JSON.parse(File.read('./test/fixtures/map.json'), symbolize_names: true)[:rooms]
  end

  def test_start_with_valid_objects
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
      Amazeingly::Application.new(
        map_file_path: './test/fixtures/map.json',
        starting_room_id: 2,
        objects: ['Knife', 'Potted Plant']
      ).start
    end

    assert_equal expected, out
  end

  def test_start_with_invalid_objects
    expected = "It's impossible to find a valid path for these objects\n"
    out, err = capture_io do
      # stub file open
      Amazeingly::Application.new(
        map_file_path: './test/fixtures/map.json',
        starting_room_id: 2,
        objects: %w(Knife Ginseng)
      ).start
    end

    assert_equal expected, out
  end

  def test_start_with_invalid_file
    expected = "Cannot read the specified input file\n"
    out, err = capture_io do
      # stub file open
      Amazeingly::Application.new(
        map_file_path: './invalid_file',
        starting_room_id: 2,
        objects: %w(Knife Ginseng)
      ).start
    end

    assert_equal expected, out
  end

  def test_start_with_invalid_room_id
    expected = "Invalid starting Room ID\n"
    out, err = capture_io do
      # stub file open
      Amazeingly::Application.new(
        map_file_path: './test/fixtures/map.json',
        starting_room_id: 20,
        objects: %w(Knife Laptop)
      ).start
    end

    assert_equal expected, out
  end
end
