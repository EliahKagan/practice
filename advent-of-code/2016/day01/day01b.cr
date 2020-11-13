# Advent of Code, day 1, part B

require "complex"
require "option_parser"

TURNS = {
  'L' => Complex.new(0, 1),
  'R' => Complex.new(0, -1),
}

def find_first_revisited_position(input, debug)
  orientation = Complex.new(0, 1)
  position = Complex.zero
  trail = Set{position}

  input.scan(/([LR])(\d+)/) do |(_, turn, distance)|
    STDERR.puts "DEBUG: turn=\"#{turn}\", distance=\"#{distance}\"" if debug
    orientation *= TURNS[turn[0]]
    distance.to_i.times do
      position += orientation
      return position unless trail.add?(position)
    end
  end
  nil
end

debug = false
OptionParser.parse do |parser|
  parser.on "--debug", "Show regex debugging information" do
    debug = true
  end
  parser.on "--help", "Show help" do
    puts parser
    exit
  end
end


if hit = find_first_revisited_position(ARGF.gets_to_end, debug)
  puts (hit.real + hit.imag).abs.to_i
else
  puts "No location was visited twice."
end
