# Advent of Code 2020, day 23, part A

require "option_parser"

MIN_CUP = 1
MAX_CUP = 9
HANDFUL = 3
DEFAULT_GAME_LENGTH = 100

def read_cups
  cups = ARGF.gets_to_end.strip.chars.map(&.to_i)
  raise "missing or duplicate cups" unless cups.sort == (MIN_CUP..MAX_CUP).to_a
  cups
end

def preferred_destination(cup)
  cup == MIN_CUP ? MAX_CUP : cup - 1
end

game_length = DEFAULT_GAME_LENGTH

OptionParser.parse do |parser|
  parser.on "-c COUNT", "--count=COUNT", "number of moves to take" do |count|
    game_length = count.to_i
  end
  parser.on "-h", "--help", "show options help" do
    puts parser
    exit
  end
end

cups = read_cups

game_length.times do
  # Keep track of the current cup's value, as even this cup may be moved.
  cur_cup = cups.first

  # Pick up a handful of cups immedately clockwise of the current cup.
  hand = cups.delete_at(1, HANDFUL)

  # Select a destination cup.
  dest_cup = preferred_destination(cur_cup)
  while hand.includes?(dest_cup)
    dest_cup = preferred_destination(dest_cup)
  end

  # Place the picked up cups immediately clockwise of the destination cup.
  dest_index = cups.index(dest_cup) || raise "Bug: destination cup not in list"
  cups = cups[..dest_index] + hand + cups[(dest_index + 1)..]

  # Select the new current cup by rotating the list so that it is first.
  cur_index = cups.index(cur_cup) || raise "Bug: current cup not in list"
  cups.rotate!(cur_index + 1)
end

min_cup_index = cups.index(MIN_CUP) || raise "Bug: min-value cup not in list"
puts cups.rotate(min_cup_index).skip(1).join

