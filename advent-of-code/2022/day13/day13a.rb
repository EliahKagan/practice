#!/usr/bin/env ruby
# frozen_string_literal: true

# Advent of Code 2022, day 23, part A
#
# This problem consists of two things Ruby almost provides directly: parsing
# the lists/arrays, and comparing them lexicographically. However:
#
# 1. It is best to parse them in way that cannot execute arbitrary code, so I
#    implement the parsing manually.
#
# 2. When an integer n is compared to an array a, we need to coerce n to [n]
#    before the comparison, and we need to do that coercion recursively
#    whenever needed. So I implement the lexicographic comparison manually.

$VERBOSE = true

# Parser to safely build nested lists of Integers from untrusted strings.
#
# Bad input should not cause arbitrary code execution, but it is fine for it to
# cause an error or an incorrect result. So this is safe, but not robust.
class Parser
  def initialize(expression)
    @parsed = false
    @tokens = lex(expression)
    raise 'no tokens in expression' if @tokens.empty?
  end

  def parse
    raise 'already parsed (or tried to)' if @parsed

    @parsed = true
    value = parse_term
    raise 'extra tokens after full expression' unless @tokens.empty?

    value
  end

  private

  def lex(expression)
    expression.scan(/[\[\]]|\d+/).map do |lexeme|
      case lexeme
      when '['
        :open
      when ']'
        :close
      else
        Integer(lexeme)
      end
    end
  end

  def parse_term
    case token = @tokens.shift
    when Integer
      token
    when :open
      parse_list
    when :close
      raise "unmatched ']'"
    when nil
      raise "unmatched '['"
    else
      raise "Bug: unrecognized token #{token.inspect}"
    end
  end

  def parse_list
    values = []
    values << parse_term while @tokens.first != :close
    @tokens.shift
    values
  end
end

def compare(lhs, rhs)
  case [lhs.class, rhs.class]
  when [Integer, Integer]
    lhs <=> rhs
  when [Integer, Array]
    compare_arrays([lhs], rhs)
  when [Array, Integer]
    compare_arrays(lhs, [rhs])
  when [Array, Array]
    compare_arrays(lhs, rhs)
  else
    raise TypeError, "Bug: wrong types #{lhs.class} and #{rhs.class}"
  end
end

def compare_arrays(lhs_array, rhs_array)
  min_size = [lhs_array.size, rhs_array.size].min
  lhs_short = lhs_array.lazy.take(min_size)
  rhs_short = rhs_array.lazy.take(min_size)

  lhs_short.zip(rhs_short) do |lhs, rhs|
    result = compare(lhs, rhs)
    return result unless result.zero?
  end

  lhs_array.size <=> rhs_array.size
end

def run
  sum = ARGF.map(&:strip)
            .reject(&:empty?)
            .map { |expression| Parser.new(expression).parse }
            .each_slice(2) # Chunk into pairs.
            .with_index(1) # Give each pair an index, starting at 1.
            .select { |(lhs, rhs), _| compare(lhs, rhs) <= 0 }
            .sum { |(_, _), index| index }

  puts sum
end

run if $PROGRAM_NAME == __FILE__
