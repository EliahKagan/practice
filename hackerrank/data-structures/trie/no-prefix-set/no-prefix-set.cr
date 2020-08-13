# https://www.hackerrank.com/challenges/no-prefix-set

alias Trie = Hash(Char, Trie)

def make_trie
  {} of Char => Trie
end

# Adds *word* to *trie*, but word must neither be nor have as a prefix any
# existing word in *trie*. Returns true on success and false on failure.
def add(trie, word)
  raise ArgumentError.new(%q{word contains '\0'}) if word.includes?('\0')

  node = trie
  word.each_char do |ch|
    node = node[ch] ||= make_trie
    return false if node.has_key?('\0') # Some previous word is a prefix.
  end

  return false unless node.empty? # This is a prefix of some previous word.
  node['\0'] = make_trie
  true
end

# Returns the first word that is a prefix or suffix of a preceding word, or nil
# if there is no such word (i.e., if *words* is a "no-prefix set").
def find_prefix_or_suffix(words)
  trie = make_trie
  words.find { |word| !add(trie, word) }
end

count = gets.as(String).to_i
match = find_prefix_or_suffix(STDIN.each_line.first(count).map(&.strip))
if match
  puts "BAD SET"
  puts match
else
  puts "GOOD SET"
end
