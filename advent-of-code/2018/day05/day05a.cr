# Advent of Code 2018, day 5, part A

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

class String
  def to_chain
    chain = Chain(Char).new
    each_char { |c| chain << c }
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
  chain = text.to_chain
  chain.contract { |lhs, rhs| lhs != rhs && lhs.downcase == rhs.downcase }

  if verbose
    result = chain.join
    pp result
    puts result.size
  else
    puts chain.size
  end
end
