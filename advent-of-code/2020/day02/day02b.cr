# Advent of Code 2020, day 2, part B

def to_zero_based_index(one_based_index_text)
  one_based_index_text.to_i - 1
end

valid_count = ARGF.each_line.count do |line|
  next false unless line =~ /^\s*(\d+)-(\d+)\s+(\w):\s+(\w+)\s*$/

  _, istr, jstr, charstr, password = $~
  i = to_zero_based_index(istr)
  j = to_zero_based_index(jstr)
  len = password.size
  next false unless 0 <= i && i < len && 0 <= j && j < len

  char = charstr[0]
  (password[i] == char) != (password[j] == char)
end

puts valid_count
