module Amazeingly
  class Path
    def initialize(raw_path = [])
      @path = []
      raw_path.each { |step| push(room: step[:room], collected_objects: step[:collected_objects] || []) }
    end

    def steps
      path.to_a
    end

    def push(room:, collected_objects: [])
      path << generate_step(room: room, collected_objects: collected_objects)
    end

    def last_visited_room
      steps.any? ? steps.last[:room] : nil
    end

    def visited_rooms
      path.map { |step| step[:room] }.uniq
    end

    def merge!(other_path)
      other_path.steps.each do |step|
        push(room: step[:room], collected_objects: step[:collected_objects]) if step[:room] != last_visited_room
      end
      self
    end

    def collected_objects
      steps.reduce([]) { |acc, elem| acc + elem[:collected_objects] }
    end

    def ==(other_path)
      other_path && (steps == other_path.steps)
    end

    private

    attr_reader :path

    def generate_step(room:, collected_objects: [])
      number = path.count + 1
      { step_number: number, room: room, collected_objects: collected_objects }
    end
  end
end
