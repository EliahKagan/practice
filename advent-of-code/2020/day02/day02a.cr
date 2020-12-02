# Advent of Code 2020, day 2, part A

valid_count = ARGF.each_line.count do |line|
  next false unless line =~ /^\s*(\d+)-(\d+)\s+(\w):\s+(\w+)\s*$/

  _, min, max, char, password = $~
  min.to_i <= password.count(char) <= max.to_i
end

puts valid_count
