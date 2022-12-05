#!/usr/bin/env ruby
# frozen_string_literal: true

# Advent of Code 2022, day 5, part A

$VERBOSE = true

# The width of a column in the input. This cannot be changed arbitrarily
# without changing how the input is formatted. A "crate" like "[A]" takes 3
# characters to write, which becomes 4 due to blank columns separating crates.
COLUMN_WIDTH = 4

# Regular expression to match a crate-movement instruction.
INSTRUCTION_PATTERN = /\Amove\s+(\d+)\s+from\s+(\d+)\s+to\s+(\d+)\z/

# Extensions for more readable fluent use of Enumerable.
module Enumerable
  def take_until
    take_while { |elem| !yield elem }
  end
end

# 1-based indexed stacks of crates.
class Stacks
  def initialize(count)
    @stacks = [nil] + Array.new(count) { [] }
  end

  def add(index, crate)
    check(index)
    @stacks[index] << crate
  end

  def move(from_index, to_index, count)
    check(from_index)
    check(to_index)

    if @stacks[from_index].size < count
      message = sprintf("can't move %d crates from stack %d (has %d crates)",
                        count, from_index, @stacks[from_index].size)
      raise IndexError, message
    end

    @stacks[to_index].concat(@stacks[from_index].pop(count).reverse!)
  end

  def tops
    results = @stacks.drop(1).map(&:last)
    raise 'some stacks were empty' if results.any?(&:nil?)

    results
  end

  private

  def check(index)
    return if index.between?(1, @stacks.size - 1)

    raise IndexError, "index #{index} out of range"
  end
end

def read_lines_lazy(file)
  file.lazy.map(&:rstrip)
end

def read_stacks(file)
  chart = read_lines_lazy(file).drop_while(&:empty?).take_until(&:empty?).to_a
  indices = chart.pop.split.map(&:to_i)
  count = indices.size
  raise "indices should be 1 to #{count}" if indices != (1..count).to_a

  stacks = Stacks.new(count)

  chart.reverse_each do |line|
    indices.each do |stack_index|
      string_index = COLUMN_WIDTH * (stack_index - 1)
      next if line[string_index] != '['

      raise 'unmatched "["' if line[string_index + 2] != ']'

      stacks.add(stack_index, line[string_index + 1])
    end
  end

  stacks
end

def run(file = ARGF)
  stacks = read_stacks(file)

  file.map(&:strip).reject(&:empty?).each do |line|
    match = line.match(INSTRUCTION_PATTERN)
    raise "bad instruction: #{line}" if match.nil?

    count, from_index, to_index = match.captures.map(&:to_i)
    stacks.move(from_index, to_index, count)
  end

  puts stacks.tops.join
end

run if $PROGRAM_NAME == __FILE__
