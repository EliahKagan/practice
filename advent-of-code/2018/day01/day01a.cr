# Advent of Code 2018, day 1, part A

puts ARGF.each_line.reject(&.empty?).map(&.to_i).sum
