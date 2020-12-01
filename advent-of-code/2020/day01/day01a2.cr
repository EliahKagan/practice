# Advent of Code 2020, day 1, part A (alternative implementation)

TARGET = 2020

values = ARGF.each_line.reject(&.empty?).map(&.to_i).to_a.sort!

left = 0
right = values.size - 1

while left < right
  if values[left] + values[right] < TARGET
    left += 1
  elsif values[left] + values[right] > TARGET
    right -= 1
  else
    puts values[left] * values[right]
    exit 0
  end
end

exit 1
