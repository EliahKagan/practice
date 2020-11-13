# Advent of Code 2016, day 6, part A

rows = ARGF.each_line.map(&.strip).reject(&.empty?).to_a
raise "No rows read from input" if rows.empty?

width = rows.first.size
raise "Got jagged input" if rows.any? { |row| row.size != width }

all_freqs = Array(Hash(Char, Int32)).new(width) { {} of Char => Int32 }
rows.each do |row|
  row.each_char.with_index do |ch, j|
    if all_freqs[j].has_key?(ch)
      all_freqs[j][ch] += 1
    else
      all_freqs[j][ch] = 1
    end
  end
end

most_common = all_freqs.map do |freqs|
  best_ch, _ = freqs.max_by { |ch, freq| freq }
  best_ch
end
puts most_common.join
