# Advent of Code 2020, day 18, part B

require "option_parser"

alias Val = Int64

class String
  def to_val? : Val?
    to_i64?
  end
end

struct LeftParen
end

struct RightParen
end

struct Add
  def call(arg1, arg2)
    arg1 + arg2
  end

  def precedence
    0
  end
end

struct Multiply
  def call(arg1, arg2)
    arg1 * arg2
  end

  def precedence
    1
  end
end

alias BinaryOp = Add | Multiply

PUNCTUATORS = {
  "(" => LeftParen.new,
  ")" => RightParen.new,
  "+" => Add.new,
  "*" => Multiply.new,
}

alias Token = Val | LeftParen | RightParen | BinaryOp

def lex(expr)
  expr.split(/\s+|\b|(?=[[:punct:]])/).reject(&.empty?).map do |lexeme|
    lexeme.to_val? || PUNCTUATORS[lexeme]
  end
end

# Shunting-yard algorithm for left-associating binary operators.
def to_rpn(tokens : Enumerable(Token))
  stack = [] of LeftParen | BinaryOp
  rpn = [] of Val | BinaryOp

  tokens.each do |token|
    if token.is_a?(Val)
      rpn << token
    elsif token.is_a?(LeftParen)
      stack << token
    elsif token.is_a?(RightParen)
      until (top = stack.pop).is_a?(LeftParen)
        rpn << top
      end
    else # BinaryOp
      while (top = stack.last?).is_a?(BinaryOp) &&
            top.precedence <= token.precedence
        rpn << top
        stack.pop
      end
      stack << token
    end
  end

  until stack.empty?
    if (top = stack.pop).is_a?(LeftParen)
      raise "unmatched left parenthesis"
    else
      rpn << top
    end
  end

  rpn
end

def eval_rpn(rpn : Enumerable(Val | BinaryOp))
  stack = [] of Val

  rpn.each do |symbol|
    if symbol.is_a?(Val)
      stack << symbol
    else # BinaryOp
      arg2 = stack.pop
      arg1 = stack.pop
      stack << symbol.call(arg1, arg2)
    end
  end

  raise "unevaluable RPN, got stack: #{stack}" if stack.size != 1
  stack.pop
end

verbose = false

OptionParser.parse do |parser|
  parser.on "-v", "--verbose", "Print the result of evaluating each line" do
    verbose = true
  end
  parser.on "-h", "--help", "Print options help" do
    puts parser
    exit
  end
end

results = ARGF.each_line.map(&.strip).reject(&.empty?).map do |expr|
  result = eval_rpn(to_rpn(lex(expr)))
  puts result if verbose
  result
end

puts results.sum
