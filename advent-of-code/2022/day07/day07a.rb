#!/usr/bin/env ruby
# frozen_string_literal: true

# Advent of Code 2022, day 7, part A

$VERBOSE = true

require 'optparse'
require_relative 'tree'

DEFAULT_CUTOFF = 100_000

def parse_options
  options = {
    cutoff: DEFAULT_CUTOFF,
    verbose: false
  }

  OptionParser.new do |parser|
    parser.on('-c', '--cutoff CUTOFF',
              "Total size cutoff (default: #{DEFAULT_CUTOFF})") do |arg|
      options[:cutoff] = Integer(arg)
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
  puts "Size cutoff is #{options[:cutoff]}.\n" if options[:verbose]

  root = Tree::Builder.build_from(ARGF)
  total = 0

  root.total_sizes do |dir, size|
    next if size > options[:cutoff]

    puts "#{dir.path} (#{size})" if options[:verbose]
    total += size
  end

  if options[:verbose]
    puts "\nSum of total sizes of matching directories is #{total}."
  else
    puts total
  end
end

run if $PROGRAM_NAME == __FILE__
