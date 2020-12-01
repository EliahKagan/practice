# Advent of Code 2020, day 1, part B

TARGET = 2020_i64

values = ARGF.each_line.reject(&.empty?).map(&.to_i64).to_a.sort!

2.upto(values.size - 1) do |right|
  subtarget = TARGET - values[right]

  left = 0
  mid = right - 1

  while left < mid
    if values[left] + values[mid] < subtarget
      left += 1
    elsif values[left] + values[mid] > subtarget
      mid -= 1
    else
      puts values[left] * values[mid] * values[right]
      exit 0
    end
  end
end

exit 1
