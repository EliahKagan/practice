# frozen_string_literal: true

# Parsing and doing lexicographic comparisons on nested arrays of integers.
module Nest
  # Safely build nested arrays of Integers from untrusted strings.
  #
  # Bad input should not cause arbitrary code execution, but it is fine for it
  # to cause an error or an incorrect result. So this is safe, but not robust.
  def self.parse(expression)
    Parser.new(expression).parse
  end

  # Compare nested arrays of Integers lexicographically, with the special rule,
  # applied recursively, that comparing an Integer n to an Array a is permitted
  # and achieved by coercing n to [n].
  def self.compare(lhs, rhs)
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

  private_class_method def self.compare_arrays(lhs_array, rhs_array)
    min_size = [lhs_array.size, rhs_array.size].min
    lhs_short = lhs_array.lazy.take(min_size)
    rhs_short = rhs_array.lazy.take(min_size)

    lhs_short.zip(rhs_short) do |lhs, rhs|
      result = compare(lhs, rhs)
      return result unless result.zero?
    end

    lhs_array.size <=> rhs_array.size
  end

  # Parser to safely build nested arrays of Integers from untrusted strings.
  class Parser
    def initialize(expression)
      @parsed = false
      @tokens = tokenize(expression)
      raise 'no tokens in expression' if @tokens.empty?
    end

    def parse
      raise 'already parsed (or tried to)' if @parsed

      @parsed = true
      value = parse_term
      raise 'extra tokens after full expression' unless @tokens.empty?

      value
    end

    def tokenize(expression)
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
        parse_array
      when :close
        raise "unmatched ']'"
      when nil
        raise "unmatched '['"
      else
        raise "Bug: unrecognized token #{token.inspect}"
      end
    end

    def parse_array
      values = []
      values << parse_term while @tokens.first != :close
      @tokens.shift
      values
    end
  end
  private_constant :Parser
end
