# Advent of Code 2020, day 19, part B scratchwork

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

rules = {} of Int32 => (-> String)

make_rule = ->(id : Int32, expr : String) do
  if expr =~ /^"([^"]+)"$/
    _, literal = $~
    escaped = Regex.escape(literal)
    ->{ escaped }
  else
    template = expr
      .split(/\s+\|\s+/) # alternation
      .map(&.split(/\s+/).map(&.to_i)) # concatenation

    ->do
      rules[id] = ->{ raise "cyclic dependency for rule #{id}" }

      alternatives = template.map(&.map { |id| rules[id].call }.join)

      if alternatives.size == 1
        pattern = alternatives.first
      else
        pattern = "(?:#{alternatives.join('|')})"
      end

      rules[id] = ->{ pattern }
      puts "#{id}: #{pattern}"
      pattern
    end
  end
end

each_line_in_stanza do |rule|
	digits, expr = rule.split(/:\s+/)
	id = digits.to_i
  rules[id] = make_rule.call(id, expr)
end

#rules[42].call
rules[31].call
