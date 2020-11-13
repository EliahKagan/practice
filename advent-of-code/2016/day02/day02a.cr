# Advent of Code 2016, day 2, part A

GRID_SIZE = 3

class Position
  def initialize(@row : Int32, @col : Int32)
    raise ArgumentError.new("no such row") unless 0 <= row < GRID_SIZE
    raise ArgumentError.new("no such column") unless 0 <= col < GRID_SIZE
  end

  def initialize(value : Int32)
    unless 1 <= value <= GRID_SIZE**2
      raise ArgumentError.new("value corresponds to no position")
    end

    initialize(row: (value - 1) // GRID_SIZE,
               col: (value - 1) % GRID_SIZE)
  end
  
  def value
    @row * GRID_SIZE + @col + 1
  end

  def move(direction)
    case direction
    when 'U'
      @row = Math.max(0, @row - 1)
    when 'D'
      @row = Math.min(GRID_SIZE - 1, @row + 1)
    when 'L'
      @col = Math.max(0, @col - 1)
    when 'R'
      @col = Math.min(GRID_SIZE - 1, @col + 1)
    else
      raise ArgumentError.new("unrecognized direction")
    end
    nil
  end
end

position = Position.new(5)

ARGF.each_line do |line|
  line.strip.each_char { |direction| position.move(direction) }
  print position.value
end

puts
