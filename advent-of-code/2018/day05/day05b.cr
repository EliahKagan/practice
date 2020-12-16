# Advent of Code 2018, day 5, part B

require "option_parser"

class Chain(T)
  include Enumerable(T)

  def each(&block)
    pos = @first
    while pos
      yield pos.value
      pos = pos.right
    end
  end

  def <<(value : T)
    if (first = @first) && (last = @last)
      @last = last.right = Node(T).new(value, last, nil)
    elsif first || last
      raise "Bug: corrupted list: just one endpoint"
    else
      @first = @last = Node(T).new(value, nil, nil)
    end
  end

  def contract(&block)
    left = @first

    while left && (right = left.right)
      unless yield(left.value, right.value)
        left = right
        next
      end

      if righter = right.right
        righter.left = left.left
      else
        @last = left.left
      end

      if lefter = left.left
        lefter.right = right.right
        left = lefter
      else
        left = @first = right.right
      end
    end
  end

  private class Node(T)
    def initialize(@value : T, @left : Node(T)?, @right : Node(T)?)
    end

    getter value

    property left, right
  end

  @first : Node(T)? = nil
  @last : Node(T)? = nil
end

module Enumerable(T)
  def to_chain
    chain = Chain(T).new
    each { |value| chain << value }
    chain
  end
end

verbose = false

OptionParser.parse do |parser|
  parser.on "-v", "--verbose", "Print the final string, not just its length" do
    verbose = true
  end
  parser.on "-h", "--help", "Show options help" do
    puts parser
    exit
  end
end

ARGF.each_line.map(&.strip).reject(&.empty?).each do |text|
  results = text.each_char.map(&.downcase).to_set.to_a.sort!.map do |ch|
    chain = text.each_char.reject { |c| c.downcase == ch }.to_chain
    chain.contract { |lhs, rhs| lhs != rhs && lhs.downcase == rhs.downcase }
    chain.join
  end

  shortest = results.min_by(&.size)
  pp shortest if verbose
  puts shortest.size
end
