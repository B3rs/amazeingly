class Room
  attr_reader :id, :name, :north, :south, :east, :west, :objects
  def initialize(args = {})
    @id       = args[:id]
    @name     = args[:name]
    @north    = args.fetch(:north, [])
    @south    = args.fetch(:south, [])
    @east     = args.fetch(:east, [])
    @west     = args.fetch(:west, [])
    @objects  = args.fetch(:objects, [])
  end
end
