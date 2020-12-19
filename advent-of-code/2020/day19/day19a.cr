# Advent of Code 2020, day 19, part A

require "option_parser"

module Iterator(T)
  def take_until(&block : T -> B) forall B
    take_while { |item| !block.call(item) }
  end
end

def each_line_in_stanza
  ARGF.each_line.map(&.strip).take_until(&.empty?)
end

def each_line_in_stanza(&block)
  each_line_in_stanza.each { |line| yield line }
end

show_pattern = false
show_matches = false

OptionParser.parse do |parser|
  parser.on "-p", "--pattern", "Show the constructed pattern" do
    show_pattern = true
  end
  parser.on "-g", "--grep", "Show the matching lines (like grep)" do
    show_matches = true
  end
  parser.on "-h", "--help", "Show options help" do
    puts parser
    exit
  end
end

rules = {} of Int32 => (-> String)

make_nonterminal_rule = ->(id : Int32, template : Array(Array(Int32))) do
  ->do
    rules[id] = ->{ raise "cyclic dependency for rule #{id}" }

    alternatives = template.map(&.map { |k| rules[k].call }.join)

    if alternatives.size == 1
      pattern = alternatives.first
    else
      pattern = "(?:#{alternatives.join('|')})"
    end

    rules[id] = ->{ pattern }
    pattern
  end
end

add_rule = ->(id : Int32, expr : String) do
  if expr =~ /^"([^"]+)"$/
    _, literal = $~
    escaped = Regex.escape(literal)
    rules[id] = ->{ escaped }
  else
    template = expr
      .split(/\s+\|\s+/) # alternation
      .map(&.split(/\s+/).map(&.to_i)) # concatenation

    rules[id] = make_nonterminal_rule.call(id, template)
  end
end

each_line_in_stanza do |rule|
	id_digits, expr = rule.split(/:\s+/)
  add_rule.call(id_digits.to_i, expr)
end

pattern = rules[0].call

if show_pattern
  puts pattern
  puts
end

line_regex = /^#{pattern}$/

count = each_line_in_stanza.count do |text|
  is_match = text.matches?(line_regex)
  puts text if show_matches && is_match
  is_match
end

puts if show_matches
puts count
