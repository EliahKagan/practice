# Advent of Code 2020, day 10, part B

STEPS = {1, 2, 3}

joltages = ARGF.each_line.map(&.strip).reject(&.empty?).map(&.to_i).to_a.sort!
joltages << joltages.last + 3

ways = [0i64] * (joltages.last + 1)
ways[0] = 1i64

get = ->(j : Int32) { j < 0 ? 0i64 : ways[j] }
joltages.each { |j| ways[j] = STEPS.sum { |step| get.call(j - step) } }

puts ways.last
