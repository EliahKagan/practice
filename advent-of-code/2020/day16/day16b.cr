# Advent of Code 2020, day 16, part B

module Iterator(T)
  def take_until(&block : T -> B) forall B
    take_while { |item| !block.call(item) }
  end
end

class PermutationConstraintSolver
  def initialize(allowed_ys) # allowed_ys[x] are the ys allowed for x.
    allowed_ys = allowed_ys.to_a
    raise "Order must be positive." if allowed_ys.empty?

    @constraints = allowed_ys.map do |ys|
      unless ys.all? { |y| 0 <= y < allowed_ys.size }
        raise "y value out of range."
      end
      ys.reduce(0) { |acc, y| acc | (1 << y) }
    end

    @chain = Array(Int32).new(allowed_ys.size)
  end

  def solve
    check_chain_size

    unless @solved_or_exhausted
      raise "Bug: not solved but a solution is populated?" unless @chain.empty?
      dfs(full_mask)
      check_chain_size
      @solved_or_exhausted = true
    end

    @chain.empty? ? nil : @chain.dup
  end

  # First, I'm going to try a simple backtracking solution with no memoization.
  private def dfs(mask)
    if mask.zero?
      raise "Bug: inconsistent solver state during run" if @chain.size != order
      return true
    end

    x = @chain.size
    choices = @constraints[x] & mask
    return false if choices.zero? # Simple optimization, not sure if it helps.

    0.upto(order - 1) do |y|
      bit = 1 << y
      next if (choices & bit).zero?

      @chain.push(y)
      return true if dfs(mask & ~bit)
      @chain.pop
    end

    false
  end

  private def order
    @constraints.size
  end

  private def full_mask
    (1 << order) - 1
  end

  private def check_chain_size
    unless @chain.empty? || @chain.size == order
      raise "Bug: corrupted solver state between runs"
    end
  end

  @constraints : Array(Int32) # x -> bitfield of allowed ys
  @chain : Array(Int32) # Partial solution during backtracking.
  @solved_or_exhausted = false
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

def assemble_constraint_problem(fields, tickets)
  longform_problem = with_possible_column_indices(fields, tickets.transpose)

  puts "Assembling problem. Possible column indices for each field:"
  longform_problem.each { |field, indices| puts "#{field}:  #{indices}" }
  puts

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

def solve_constraint_problem(longform_problem)
  allowed_cols = longform_problem.map { |_field, indices| indices }
  solution = PermutationConstraintSolver.new(allowed_cols).solve

  unless solution
    puts "No solution!"
    exit 1
  end

  fields = longform_problem.map { |field, _indices| field }

  column_fields = solution.zip(fields)
    .sort_by! { |col, _field| col }
    .map { |_col, field| field }

  puts "Solved. The fields, by column number, are as follows."
  column_fields.each_with_index do |field, col|
    puts "Column ##{col}:  #{field}"
  end
  puts

  column_fields
end

def display_your_ticket(column_fields, your_ticket)
  if column_fields.size != your_ticket.size
    raise "Bug: wrong number of solution field labels for your ticket"
  end

  puts "The fields of your ticket, with their values, are thus as follows."
  column_fields.zip(your_ticket) { |field, value| puts "#{field}:  #{value}" }
  puts
end

def report_departure_product(column_fields, your_ticket)
  departure_product = column_fields
    .map(&.name)
    .zip(your_ticket)
    .select { |name, _value| name.starts_with?("departure") }
    .product { |_name, value| value.to_i64 }

  puts "The product of the departure fields' values is:  #{departure_product}"
end

fields, tickets = process_input
longform_problem = assemble_constraint_problem(fields, tickets)
column_fields = solve_constraint_problem(longform_problem)
display_your_ticket(column_fields, tickets.first)
report_departure_product(column_fields, tickets.first)
