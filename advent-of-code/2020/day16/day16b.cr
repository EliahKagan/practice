# Advent of Code 2020, day 16, part B

module Iterator(T)
  def take_until(&block : T -> B) forall B
    take_while { |item| !block.call(item) }
  end
end

class PermutationConstraintSolver
  def initialize(allowed_y_rows)
    allowed_y_rows = allowed_y_rows.to_a
    raise "Order must be positive." if allowed_y_rows.empty?

    @constraints = allowed_y_rows.map do |ys|
      unless ys.all? { |y| 0 <= y < allowed_y_rows.size }
        raise "y value out of range."
      end
      ys.reduce(0) { |acc, y| acc | (1 << y) }
    end
  end

  # FIXME: implement the rest!

  private def order
    @constraints.size
  end

  @constraints : Array(Int32) # x -> bitfield of allowed ys
  # @memo : ???
end

struct Field
  def initialize(text : String)
    unless text =~ /^([^:]*[^:\s]):\s+(\d+)-(\d+)\s+or\s+(\d+)-(\d+)$/
      raise "Malformed field constraint specification."
    end
    _, @name, start1, end1, start2, end2 = $~
    @range1 = start1.to_i..end1.to_i
    @range2 = start2.to_i..end2.to_i
  end

  def to_s(io)
    io << @name
  end

  def allows?(value : Int32)
    @range1.includes?(value) || @range2.includes?(value)
  end

  getter name : String

  @range1 : Range(Int32, Int32)
  @range2 : Range(Int32, Int32)
end

def each_line_in_stanza
  ARGF.each_line.map(&.strip).take_until(&.empty?)
end

def each_line_in_stanza(&block)
  each_line_in_stanza.each { |line| yield line }
end

def read_field_constraints
  fields = each_line_in_stanza.map { |line| Field.new(line) }.to_a
  raise "No fields listed, expected at least one." if fields.empty?
  fields
end

def consume_line(text)
  ARGF.each_line.map(&.strip).take_until { |line| line == text }.each do |line|
    raise %Q{Expected "#{text}", got "#{line}."}
  end
end

def parse_ticket(text, field_count)
  ticket = text.split(',').map(&.to_i)
  unless ticket.size == field_count
    raise "Got ticket with field count #{ticket.size}, need #{field_count}."
  end
  ticket
end

def read_ticket_stanza(tickets_sink, field_count, label)
	consume_line("#{label}:")
  each_line_in_stanza do |line|
    tickets_sink << parse_ticket(line, field_count)
  end
end

def read_all_tickets(field_count)
  tickets = [] of Array(Int32)

  read_ticket_stanza(tickets, field_count, "your ticket")
  if tickets.size != 1
    raise "Expected you to have 1 ticket, got #{tickets.size}."
  end

  read_ticket_stanza(tickets, field_count, "nearby tickets")

  tickets
end

def plausible?(ticket, fields)
  ticket.all? { |value| fields.any?(&.allows?(value)) }
end

def drop_implausible_tickets(tickets, fields)
  tickets.select! { |ticket| plausible?(ticket, fields) }
end

def process_input
  fields = read_field_constraints

  tickets = read_all_tickets(fields.size)
  old_count = tickets.size
  your_ticket = tickets.first

  if old_count == 1
    puts "Read #{old_count} ticket, including yours."
  else
    puts "Read #{old_count} tickets, including yours."
  end

  drop_implausible_tickets(tickets, fields)
  count = tickets.size

  if count == 1
    puts "Dropped #{old_count - count} as implausible. #{count} remains."
  else
    puts "Dropped #{old_count - count} as implausible. #{count} remain."
  end

  unless tickets.first.same?(your_ticket)
    raise "Your ticket was one of the implausible ones!"
  end

  puts
  {fields, tickets}
end

def with_possible_column_indices(fields, columns)
  possibles = fields.map do |field|
    (0...columns.size).select do |index|
      columns[index].all? { |value| field.allows?(value) }
    end
  end

  fields.zip(possibles)
end

def assemble_problem(fields, tickets)
  longform_problem = with_possible_column_indices(fields, tickets.transpose)

  puts "Assembling problem. Possible column indices for each field:"
  longform_problem.each { |field, indices| puts "#{field}: #{indices}" }

  unsatisfiables = longform_problem
    .select { |_field, indices| indices.empty? }
    .map { |field, _indices| field }

  unless unsatisfiables.empty?
    if unsatisfiables.size == 1
      raise "Clearly unsatisfiable field: #{unsatisfiables.first}"
    else
      raise %Q<Clearly unsatisfiable fields: #{unsatisfiables.join(", ")}>
    end
  end

  longform_problem.sort_by! { |field, indices| indices.size }
end

fields, tickets = process_input
longform_problem = assemble_problem(fields, tickets)
