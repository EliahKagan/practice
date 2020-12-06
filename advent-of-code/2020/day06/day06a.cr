# Advent of Code 2020, day 6, part A

stanzas = ARGF.each_line(delimiter: "\n\n")
puts stanzas.sum(&.gsub(/\s+/, "").each_char.to_set.size)
