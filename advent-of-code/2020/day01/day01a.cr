# Advent of Code 2020, day 1, part A

TARGET = 2020

history = Set(Int32).new

ARGF.each_line.reject(&.empty?).map(&.to_i).each do |value|
  complement = TARGET - value
  if history.includes?(complement)
    puts value * complement
    exit 0
  else
    history << value
  end
end

exit 1
