# Advent of Code 2020, day 6, part B (implemented using set intersection)

stanzas = ARGF.each_line(delimiter: "\n\n")
groups = stanzas.map(&.split(/\s+/).reject(&.empty?).map(&.each_char.to_set))
puts groups.sum(&.reduce { |s, t| s & t }.size)
