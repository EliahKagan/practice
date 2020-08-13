#!/usr/bin/env ruby
# frozen_string_literal: true

# https://www.hackerrank.com/challenges/contacts

$VERBOSE = 1

# A trie for prefix counting. Does not keep track of where words end.
class Trie
  def initialize
    @root = Node.new
  end

  # Adds *word* as a chain to the trie, incrementing all its prefixes' counts.
  def add(word)
    node = @root
    word.each_char do |ch|
      node.count += 1
      node = node[ch] ||= Node.new
    end
    node.count += 1
  end

  # Counts the number of times a chain with prefix *prefix* was added.
  def count(prefix)
    node = @root
    prefix.each_char do |ch|
      node = node[ch]
      return 0 if node.nil?
    end
    node.count
  end

  # A trie node. Each node instance represents a prefix.
  class Node
    attr_accessor :count

    def initialize
      @children = {}
      @count = 0
    end

    def [](char)
      @children[char]
    end

    def []=(char, node)
      @children[char] = node
    end
  end
  private_constant :Node
end

if __FILE__ == $PROGRAM_NAME
  trie = Trie.new

  gets.to_i.times do
    command, argument = gets.split

    case command
    when 'add'
      trie.add(argument)
    when 'find'
      puts trie.count(argument)
    else
      raise "Unrecognized command: #{command}"
    end
  end
end
