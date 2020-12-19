#!/usr/bin/env ruby
# frozen_string_literal: true

# Advent of Code 2020, day 19, part B

$VERBOSE = 1

require 'English'
require 'optparse'

# Extending Enumerator with a take_until method, analogous to take_while.
class Enumerator
  def take_until
    take_while { |item| !yield(item) }
  end
end

def stanza_lines
  ARGF.each_line.lazy.map(&:strip).take_until(&:empty?)
end

def fix_rule_for_part_b(rule)
  case rule
  when '8: 42'
    '8: 42 | 42 8'
  when '11: 42 31'
    '11: 42 31 | 42 11 31'
  else
    rule
  end
end

show_pattern = false
show_matches = false

OptionParser.new do |parser|
  parser.on '-p', '--pattern', 'Show the constructed pattern' do
    show_pattern = true
  end
  parser.on '-g', '--grep', 'Show the matching lines (like grep)' do
    show_matches = true
  end
  parser.on '-h', '--help', 'Show options help' do
    puts parser
    exit
  end
end.parse!

rules = {}

make_nonterminal_rule = lambda do |id, template|
  direct_recursive = template.any? { |row| row.include?(nil) }

  lambda do
    rules[id] = -> { raise "cyclic dependency for rule #{id}" }

    alternatives = template.map do |row|
      row.map { |k| k ? rules[k].call : '\g<-1>' }.join
    end

    unparenthesized = alternatives.join('|')

    pattern =
      if direct_recursive
        "(#{unparenthesized})"
      elsif alternatives.size > 1
        "(?:#{unparenthesized})"
      else
        unparenthesized
      end

    rules[id] = -> { pattern }
    pattern
  end
end

add_rule = lambda do |id, expr|
  if expr =~ /^"([^"]+)"$/
    literal, = $LAST_MATCH_INFO.captures
    escaped = Regexp.escape(literal)
    rules[id] = -> { escaped }
  else
    branches = expr.split(/\s+\|\s+/) # alternation

    template = branches.map do |branch|
      branch.split(/\s+/)
            .map(&:to_i) # concatentation
            .map { |k| k == id ? nil : k } # direct recursion
    end

    rules[id] = make_nonterminal_rule.call(id, template)
  end
end

stanza_lines.map { |rule| fix_rule_for_part_b(rule) }.each do |rule|
  id_digits, expr = rule.split(/:\s+/)
  add_rule.call(id_digits.to_i, expr)
end

pattern = rules[0].call

if show_pattern
  puts pattern
  puts
end

line_regex = /^#{pattern}$/

count = stanza_lines.count do |text|
  is_match = text.match?(line_regex)
  puts text if show_matches && is_match
  is_match
end

puts if show_matches
puts count
