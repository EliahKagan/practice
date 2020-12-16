# Advent of Code 2020, day 16, part A

module Iterator(T)
  def take_until(&block : T -> B) forall B
    take_while { |item| !block.call(item) }
  end
end

class Constraints
  def add_field(range1, range2)
    @fields << {range1, range2}
    nil
  end

  def any_allow?(value)
    @fields.any?(&.any?(&.includes?(value)))
  end

  @fields = [] of {Range(Int32, Int32), Range(Int32, Int32)}
end

def each_line_in_stanza
  ARGF.each_line.map(&.strip).take_until(&.empty?)
end

def each_line_in_stanza(&block)
  each_line_in_stanza.each { |line| yield line }
end

def consume_line(text)
  ARGF.each_line.map(&.strip).take_until { |line| line == text }.each do |line|
    raise %Q{Expected "#{text}", got "#{line}"}
  end
end

def read_constraints
  constraints = Constraints.new
  each_line_in_stanza do |line|
    unless line =~ /^[^:]*[^:\s]:\s+(\d+)-(\d+)\s+or\s+(\d+)-(\d+)$/
      raise "malformed constraint"
    end
    _, start1, end1, start2, end2 = $~
    constraints.add_field((start1.to_i..end1.to_i), (start2.to_i..end2.to_i))
  end
  constraints
end

def read_tickets(label)
  consume_line("#{label}:")
  each_line_in_stanza.map(&.split(',').map(&.to_i)).to_a
end

def skip_your_ticket
  tickets = read_tickets("your ticket")
  raise "expected a single ticket, got none" if tickets.empty?
  raise "expected a single ticket, got more than one" if tickets.size > 1
  nil
end

constraints = read_constraints
skip_your_ticket
tickets = read_tickets("nearby tickets")

puts tickets.sum(&.reject { |ticket| constraints.any_allow?(ticket) }.sum)
