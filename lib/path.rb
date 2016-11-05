module Amazeingly
  class Path
    def initialize(raw_path = [])
      @path = raw_path
    end

    def to_a
      path.to_a
    end

    def push(room:, collected_objects:)
      path << step(room, collected_objects)
      to_a
    end

    def visited_rooms
      path.map { |step| step[:room] }.uniq
    end

    def visited_room?(room)
      path.any? { |step| step[:room] == room }
    end

    def ==(other_path)
      to_a == other_path.to_a
    end

    private

    def step(room, objects)
      { room: room, collected_objects: objects }
    end

    attr_reader :path
  end
end
