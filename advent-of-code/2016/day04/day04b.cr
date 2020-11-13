# Advent of Code 2016, day 4, part B

PATTERN = /^\s*(?<name>[a-z-]+)-(?<id>\d+)\[(?<hash>[a-z]+)\]\s*$/

ALPHA_LEN = 26

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

def rotate(ch, key)
  raise ArgumentError.new("can't rotate non-letter") unless 'a' <= ch <= 'z'
  'a' + (ch - 'a' + key) % ALPHA_LEN
end

def caesar(text, key)
  text.each_char.map { |ch| ch == '-' ? ' ' : rotate(ch, key) }.join
end

raise "Internal error: incompatible encoding" unless 'z' - 'a' + 1 == ALPHA_LEN

ARGF.each_line do |line|
  match = PATTERN.match(line)
  next if match.nil? || match["hash"] != weird_hash(match["name"])
  id = match["id"].to_i
  printf "%4d  %s\n", id, caesar(match["name"], id)
end
