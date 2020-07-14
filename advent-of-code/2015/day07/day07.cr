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
    literal_value = simple_expression.to_u16?
    if literal_value
      lv : UInt16 = literal_value # FIXME: remove after debugging
      return ->() { literal_value }
    end

    ->() do
      computed_value = variables[simple_expression].call
      variables[simple_expression] = ->() { computed_value }
      computed_value
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
      as_binary_evaluator.call(tokens[0],
                               as_nullary_evaluator.call(tokens[1]),
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

def as_mappings(lines)
  lines.map(&.strip).reject(&.empty?).map(&.split(/\s+->\s+/)).map do |tokens|
    raise "wrong syntax for mapping" unless tokens.size == 2
    {name: tokens[1], expression: tokens[0]}
  end
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

solve_tiny_example
