# Advent of Code 2020, day 19, part B

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

make_rule = ->(id : Int32, expr : String) do
  if expr =~ /^"([^"]+)"$/
    _, literal = $~
    escaped = Regex.escape(literal)
    ->{ escaped }
  else
    template = expr
      .split(/\s+\|\s+/) # alternation
      .map(&.split(/\s+/) # concatenation
            .map(&.to_i)
            .map { |k| k == id ? nil : k }) # recursion

    ->do
      rules[id] = ->{ raise "cyclic dependency for rule #{id}" }

      simple_recursive = false

      alternatives = template
        .map(&.map do |k|
            if k
              rules[k].call
            else
              simple_recursive = true
              "(?-1)"
            end
          end.join) # TODO: This is ugly and should be cleaned up.

      unparenthesized = alternatives.join('|')

      pattern =
        if simple_recursive
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
	digits, expr = rule.split(/:\s+/)
	id = digits.to_i
  rules[id] = make_rule.call(id, expr)
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
