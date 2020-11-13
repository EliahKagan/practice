# Advent of Code 2016, day 3, part B

def makes_triangle(a, b, c)
  a + b > c && b + c > a && c + a > b
end

# TODO: Split this over multiple lines with /x.
PATTERN = /(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)(?:\s+|\z)/

count = 0

ARGF.gets_to_end.scan(PATTERN)
  .map { |groups| (1..9).map { |g| groups[g].to_i } }
  .each do |sides|
    0.upto(2) do |i|
      count += 1 if makes_triangle(sides[i], sides[i + 3], sides[i + 6])
    end
  end

puts count
