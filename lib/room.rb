module Amazeingly
  class Room
    attr_reader :id, :name, :north, :south, :east, :west, :objects
    def initialize(args = {})
      @id       = args[:id]
      @name     = args[:name]
      @north    = args[:north]
      @south    = args[:south]
      @east     = args[:east]
      @west     = args[:west]
      @objects  = args.fetch(:objects, [])
    end

    def has_object?(object_name)
      !objects.find { |object| object[:name] == object_name }.nil?
    end

    def has_objects?(object_names)
      object_names.all? { |name| has_object?(name) }
    end

    def matching_objects(names)
      names.select { |name| has_object?(name) }
    end

    def object_names
      objects.map { |object| object[:name] }
    end

    def connected_room_ids
      [north, south, east, west].compact
    end

    def ==(room)
      room && (id == room.id)
    end
  end
end
