# Advent of Code 2016, day 4, part A

def nonhyphen_char_freqs(text)
  freqs = {} of Char => Int32

  text.each_char.reject { |ch| ch == '-' }.each do |ch|
    if freqs.has_key?(ch)
      freqs[ch] += 1
    else
      freqs[ch] = 1
    end
  end

  freqs
end

def weird_hash(text)
  freqs = nonhyphen_char_freqs(text).to_a.sort! do |(lch, lfreq), (rch, rfreq)|
    by_freq_descending = rfreq <=> lfreq
    by_freq_descending.zero? ? lch <=> rch : by_freq_descending
  end

  freqs.each.first(5).map { |(ch, freq)| ch }.join
end

puts weird_hash("not-a-real-room")
