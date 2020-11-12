# Advent of Code, day 1, part A

require "complex"
require "option_parser"

TURNS = {
  'L' => Complex.new(0, 1),
  'R' => Complex.new(0, -1),
}

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

orientation = Complex.new(0, 1)
position = Complex.zero

ARGF.gets_to_end.scan(/([LR])(\d+)/) do |(_, turn, distance)|
  STDERR.puts "DEBUG: turn=\"#{turn}\", distance=\"#{distance}\"" if debug
  orientation *= TURNS[turn[0]]
  position += orientation * distance.to_i
end

puts (position.real + position.imag).abs.to_i
