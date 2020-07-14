# Advent of code 2015, both parts
# Via recursion with memoization, with cycle checking.
# Implemented with a single table of procs representing thunks.
# This is like the C# version day07.linq, but in Crystal with Proc(UInt16).

def unary(&block : UInt16 -> UInt16)
  block
end

def binary(&block : (UInt16, UInt16) -> UInt16)
  block
end

UNARIES = {
  "NOT" => unary { |arg| ~arg }
}

BINARIES = {
  "AND" => binary { |arg1, arg2| arg1 & arg2 },
  "OR" => binary { |arg1, arg2| arg1 | arg2 },
  "LSHIFT" => binary { |arg1, arg2| arg1 << arg2 },
  "RSHIFT" => binary { |arg1, arg2| arg1 >> arg2 }
}

def as_variables(mappings)
  variables = Hash(String, Proc(UInt16)).new

  as_nullary_evaluator = ->(simple_expression : String) do
    case simple_expression
    when /^\d+$/
      literal_value = simple_expression.to_u16
      ->() { literal_value }
    else
      ->() do
        computed_value = variables[simple_expression].call
        variables[simple_expression] = ->() { computed_value }
        computed_value
      end
    end
  end

  as_unary_evaluator = ->(unary_function_name : String,
                          arg : Proc(UInt16)) do
    function = UNARIES[unary_function_name]
    ->() { function.call(arg.call) }
  end

  as_binary_evaluator = ->(binary_function_name : String,
                           arg1 : Proc(UInt16),
                           arg2 : Proc(UInt16)) do
    function = BINARIES[binary_function_name]
    ->() { function.call(arg1.call, arg2.call) }
  end

  as_evaluator = ->(expression : String) do
    tokens = expression.split

    case tokens.size
    when 1
      as_nullary_evaluator.call(tokens[0])
    when 2
      as_unary_evaluator.call(tokens[0], as_nullary_evaluator.call(tokens[1]))
    when 3
      as_binary_evaluator.call(tokens[1],
                               as_nullary_evaluator.call(tokens[0]),
                               as_nullary_evaluator.call(tokens[2]))
    else
      raise "malformed expression" # FIXME: Raise specific exception type?
    end
  end

  mappings.each do |mapping|
    variables[mapping[:name]] = as_evaluator.call(mapping[:expression])
  end

  variables
end

def as_single_mapping(tokens)
  raise "wrong syntax for mapping" unless tokens.size == 2
  {name: tokens[1], expression: tokens[0]}
end

def as_mappings(lines)
  lines.map(&.strip)
       .reject(&.empty?)
       .map(&.split(/\s+->\s+/)).map { |tokens| as_single_mapping(tokens) }
       .to_a
end

def solve_tiny_example
  example = <<-'END_EXAMPLE'
    123 -> x
    456 -> y
    x AND y -> d
    x OR y -> e
    x LSHIFT 2 -> f
    y RSHIFT 2 -> g
    NOT x -> h
    NOT y -> i
  END_EXAMPLE

  variables = as_variables(as_mappings(example.split('\n')))

  %w[d e f g h i x y].each do |name|
    puts "#{name}: #{variables[name].call}"
  end
end

RESULT_LABEL_WIDTH = 13
RESULT_VALUE_WIDTH = 6

def show_result(label, value)
  printf "%*s: %*d\n", RESULT_LABEL_WIDTH, label, RESULT_VALUE_WIDTH, value
end

def solve_full_problem(target, then_rewire_from, then_rewire_to)
  mappings = as_mappings(ARGF.each_line)
  variables = as_variables(mappings)
  show_result("Before rewire", variables[target].call)

  mappings << {name: then_rewire_to,
               expression: variables[then_rewire_from].call.to_s}
  show_result("After rewire", as_variables(mappings)[target].call)
end

if ARGV.empty?
  solve_tiny_example
else
  solve_full_problem("a", "a", "b")
end
