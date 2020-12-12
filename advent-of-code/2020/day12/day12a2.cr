# Advent of Code 2020, day 12, part A - alternate implementation

def compose(secondary, primary)
  m = secondary.size
  raise ArgumentError.new("empty secondary matrix not supported") if m.zero?

  n = secondary.first.size
  if secondary.any? { |row| row.size != n }
    raise ArgumentError.new(%q{jagged secondary "matrix" not supported})
  end

  if primary.empty?
    raise ArgumentError.new("empty primary matrix not supported")
  end

  p = primary.first.size
  if primary.any? { |row| row.size != p }
    raise ArgumentError.new(%q{jagged primary "matrix" not supported})
  end

  if primary.size != n
    raise ArgumentError.new(
        "can't multply #{m}-by-#{n} matrix by #{primary.size}-by-#{p} matrix")
  end

  (0...m).map do |i|
    (0...p).map do |k|
      (0...n).sum { |j| secondary[i][j] * primary[j][k] }
    end
  end
end

def apply(matrix, vector)
  compose(matrix, vector.map { |component| {component} }).map(&.first)
end

DIRECTIONS = {
  'N' => {-1,  0},
  'E' => { 0, +1},
  'S' => {+1,  0},
  'W' => { 0, -1},
}

IDENTITY = {
  {+1,  0},
  { 0, +1},
}

RIGHT_TURN = {
  { 0, +1},
  {-1,  0},
}

def turn_right(direction, degrees)
  raise ArgumentError.new("off-grid angle") if degrees % 90 != 0
  raise ArgumentError.new("negative input angle not supported") if degrees < 0

  matrix = IDENTITY
  (degrees // 90).times { matrix = compose(RIGHT_TURN, matrix) }
  apply(matrix, direction)
end

def turn_left(direction, degrees)
  turn_right(direction, 360 - degrees)
end

i = 0
j = 0
orientation = DIRECTIONS['E']

ARGF.each_line.map(&.strip).reject(&.empty?).each do |line|
  command = line[0]
  argument = line[1..].to_i

  if command == 'R'
    orientation = turn_right(orientation, argument)
    next
  end

  if command == 'L'
    orientation = turn_left(orientation, argument)
    next
  end

  di, dj = (command == 'F' ? orientation : DIRECTIONS[command])
  i += di * argument
  j += dj * argument
end

puts i.abs + j.abs
