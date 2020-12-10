# Advent of Code 2020, day 10, part A

def unit_phrase(number, unit)
  number == 1 ? "#{number} #{unit}" : "#{number} #{unit}s"
end

values = ARGF.each_line
  .map(&.strip)
  .reject(&.empty?)
  .map(&.to_i)
  .chain({0}.each)
  .to_a
  .sort!

values << values.last + 3

delta_counts = Hash(Int32, Int32).new(0)

values.each
  .cons(2)
  .map { |(first, second)| second - first }
  .each { |delta| delta_counts[delta] += 1 }

delta_counts.each.to_a.sort!.each do |delta, count|
  puts %Q<#{unit_phrase(count, "difference")} of #{unit_phrase(delta, "jolt")}>
end

puts
ones = delta_counts[1]
threes = delta_counts[3]
puts "#{ones} * #{threes} = #{ones * threes}"
