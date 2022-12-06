#!/usr/bin/env ruby
# frozen_string_literal: true

# Advent of Code 2022, day 6, part B
#
# This will alternatively solve part A if "-l 4" is passed.

$VERBOSE = true

require 'optparse'

def make_pattern(length)
  all_but_last = (1...length).map do |j|
    any_previous = (1..j).map { |i| "\\#{i}" }.join('|')
    "(.)(?!#{any_previous})"
  end
  /#{all_but_last.join}./
end

def parse_options
  options = {length: 14}

  OptionParser.new do |parser|
    parser.on('-l', '--length LENGTH', 'Length of matching text') do |arg|
      options[:length] = Integer(arg)
    end
    parser.on('-h', '--help', 'Print this help message') do
      puts parser
      exit
    end
  end.parse!

  options
end

def run
  length = parse_options[:length]
  pattern = make_pattern(length)

  ARGF.each_line do |line|
    start = pattern =~ line.strip
    puts start + length
  end
end

run if $PROGRAM_NAME == __FILE__
