#!/usr/bin/env ruby
# frozen_string_literal: true

# Advent of Code 2022, day 7, part B

$VERBOSE = true

require 'optparse'
require_relative 'tree'

DEFAULTS = {
  capacity: 70_000_000,
  need_free: 30_000_000,
  verbose: false
}.freeze

def parse_options
  options = DEFAULTS.dup

  OptionParser.new do |parser|
    parser.on('-c', '--capacity CAPACITY',
              "Total space (default: #{DEFAULTS[:capacity]})") do |arg|
      options[:capacity] = Integer(arg)
    end
    parser.on('-f', '--free FREE',
              "Space we need free (default: #{DEFAULTS[:need_free]})") do |arg|
      options[:need_free] = Integer(arg)
    end
    parser.on('-v', '--verbose', 'List each matching directory') do
      options[:verbose] = true
    end
    parser.on('-h', '--help', 'Print this help message') do
      puts parser
      exit
    end
  end.parse!

  options
end

def run
  options = parse_options
  info = ->(format, *args) { printf format, *args if options[:verbose] }

  info.call("Total capacity is %d. We need %d free.\n",
            options[:capacity], options[:need_free])

  root = Tree::Builder.build_from(ARGF)
  dir_sizes = {}
  used = root.total_sizes { |dir, size| dir_sizes[dir] = size }

  # free delta (amount we must further free) = need free - current free
  # current free = capacity - used
  # free delta = need free - (capacity - used) = need free + used - capacity
  free_delta = options[:need_free] + used - options[:capacity]
  info.call("Used space is %d, so we must free %d more.\n\n", used, free_delta)
  raise "no need to free space (#{free_delta} <= 0)" if free_delta <= 0

  best_dir, best_size = dir_sizes.select { |_, size| size >= free_delta }
                                 .min_by { |_, size| size }

  if options[:verbose]
    puts "It is optimal to delete #{best_dir.path}, which frees #{best_size}."
  else
    puts best_size
  end
end

run if $PROGRAM_NAME == __FILE__
