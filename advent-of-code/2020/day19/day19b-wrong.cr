# Advent of Code 2020, day 19, part B attempt
# This produces the wrong result, because PCRE1 recursion is atomic.

require "option_parser"

module Iterator(T)
  def take_until(&block : T -> B) forall B
    take_while { |item| !block.call(item) }
  end
end

def each_line_in_stanza
  ARGF.each_line.map(&.strip).take_until(&.empty?)
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

make_nonterminal_rule = ->(id : Int32, template : Array(Array(Int32?))) do
  direct_recursive = template.any?(&.includes?(nil))

  ->do
    rules[id] = ->{ raise "cyclic dependency for rule #{id}" }

    alternatives =
      template.map(&.map { |k| k ? rules[k].call : "(?-1)" }.join)

    unparenthesized = alternatives.join('|')

    pattern =
      if direct_recursive
        "(#{unparenthesized})"
      elsif alternatives.size > 1
        "(?:#{unparenthesized})"
      else
        unparenthesized
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
      .map(&.split(/\s+/) # concatenation
            .map(&.to_i)
            .map { |k| k == id ? nil : k }) # direct recursion

    rules[id] = make_nonterminal_rule.call(id, template)
  end
end

each_line_in_stanza.map do |rule|
  case rule
  when "8: 42"
    "8: 42 | 42 8"
  when "11: 42 31"
    "11: 42 31 | 42 11 31"
  else
    rule
  end
end.each do |rule|
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
