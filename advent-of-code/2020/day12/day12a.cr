# Advent of Code 2020, day 12, part A

DIRECTIONS = {
  'N' => {-1, 0},
  'E' => {0, +1},
  'S' => {+1, 0},
  'W' => {0, -1},
}

RIGHT_TURNS = {
  {-1, 0} => {0, +1},
  {0, +1} => {+1, 0},
  {+1, 0} => {0, -1},
  {0, -1} => {-1, 0},
}

def quarters_from_degrees(degrees)
  raise ArgumentError.new("negatve input angle not supported") if degrees < 0
  raise ArgumentError.new("off-grid angle") if degrees % 90 != 0
  (degrees // 90) % 4
end

def turn_right(direction, quarters)
  quarters.times { direction = RIGHT_TURNS[direction] }
  direction
end

def turn_left(direction, quarters)
  turn_right(direction, (4 - quarters) % 4)
end

i = 0
j = 0
orientation = DIRECTIONS['E']

ARGF.each_line.map(&.strip).reject(&.empty?).each do |line|
  command = line[0]
  argument = line[1..].to_i

  if command == 'R'
    orientation = turn_right(orientation, quarters_from_degrees(argument))
    next
  end

  if command == 'L'
    orientation = turn_left(orientation, quarters_from_degrees(argument))
    next
  end

  di, dj = (command == 'F' ? orientation : DIRECTIONS[command])
  i += di * argument
  j += dj * argument
end

puts i.abs + j.abs
