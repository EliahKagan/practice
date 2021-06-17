# LeetCode #1896 - Minimum Cost to Change the Final Value of Expression
# https://leetcode.com/problems/minimum-cost-to-change-the-final-value-of-expression/

BOOLEAN_VALUES = {
  '0' => 0,
  '1' => 1,
}

BOOLEAN_OPERATORS = {
  '&' => ->(p, q) { p & q },
  '|' => ->(p, q) { p | q },
}

FALSE_DISTANCE_OPERATORS = {
  '&' => ->(p, q) { [p, q].min },
  '|' => ->(p, q) { [p + q, [p, q].min + 1].min },
}

DUALS = {
  '0' => '1',
  '1' => '0',
  '&' => '|',
  '|' => '&',
}

# @param {String} expression
# @return {Integer}
def min_operations_to_flip(expression)
  rpn = to_rpn(expression)

  case evaluate(rpn, BOOLEAN_OPERATORS)
  when 0
    evaluate(dual(rpn), FALSE_DISTANCE_OPERATORS)
  when 1
    evaluate(rpn, FALSE_DISTANCE_OPERATORS)
  else
    raise 'truth value not 0 or 1 (this is a bug)'
  end
end

def to_rpn(infix)
  tokens = []
  shunting_yard(infix) { |token| tokens << token }
  tokens.join
end

def shunting_yard(infix)
  stack = [] # operators/punctuators

  infix.each_char do |token|
    if BOOLEAN_VALUES.has_key?(token)
      yield token
    elsif BOOLEAN_OPERATORS.has_key?(token)
      yield stack.pop while BOOLEAN_OPERATORS.has_key?(stack.last)
      stack.push(token)
    elsif token == '('
      stack.push(token)
    elsif token == ')'
      yield stack.pop while !stack.empty? && stack.last != '('
      raise 'unmatched ")"' if stack.empty?
      stack.pop
    else
      raise %{unrecognized infix token "#{token}"}
    end
  end

  until stack.empty?
    pp stack
    raise 'unmatched "("' if stack.last == '('
    yield stack.pop
  end

  nil
end

def evaluate(rpn, operators)
  stack = [] # operands

  rpn.each_char do |token|
    if operand = BOOLEAN_VALUES[token]
      stack.push(operand)
    elsif operator = operators[token]
      raise 'too few operands' if stack.size < 2

      second = stack.pop
      first = stack.pop
      stack.push(operator.call(first, second))
    else
      raise %{unrecognied RPN token "#{token}"}
    end
  end

  raise 'too few operators' if stack.size != 1
  stack.pop
end

def dual(rpn)
  rpn.chars.map do |token|
    DUALS[token] or raise %{unrecognied RPN token "#{token}"}
  end.join
end
