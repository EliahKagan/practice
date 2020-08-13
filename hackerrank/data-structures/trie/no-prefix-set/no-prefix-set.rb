#!/usr/bin/env ruby
# frozen_string_literal: true

# https://www.hackerrank.com/challenges/no-prefix-set

$VERBOSE = 1

# Adds *word* to *trie*, but word must neither be nor have as a prefix any
# existing word in *trie*. Returns true on success and false on failure.
def add(trie, word)
  node = trie

  word.each_char do |ch|
    node = node[ch] ||= {}
    return false if node.key?(nil) # Some previous word is a prefix.
  end

  return false unless node.empty? # This is a prefix of some previous word.

  node[nil] = nil
  true
end

# Returns the first word that is a prefix or suffix of a preceding word, or nil
# if there is no such word (i.e., if *words* is a "no-prefix set").
def find_prefix_or_suffix(words)
  trie = {}
  words.find { |word| !add(trie, word) }
end

if __FILE__ == $PROGRAM_NAME
  count = gets.to_i
  match = find_prefix_or_suffix(STDIN.each_line.first(count).map(&:strip))
  if match
    puts 'BAD SET'
    puts match
  else
    puts 'GOOD SET'
  end
end
