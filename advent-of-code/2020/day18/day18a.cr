# Advent of Code 2020, day 18, part A

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

alias BinaryOp = Val, Val -> Val

PUNCTUATORS = {
  "(" => LeftParen.new,
  ")" => RightParen.new,
  "+" => ->(arg1 : Val, arg2 : Val) { arg1 + arg2 },
  "*" => ->(arg1 : Val, arg2 : Val) { arg1 * arg2 },
}

alias Token = LeftParen | RightParen | BinaryOp | Val

def lex(expr)
  expr.split(/\s+|\b|(?=[[:punct:]])/).reject(&.empty?).map do |lexeme|
    lexeme.to_val? || PUNCTUATORS[lexeme]
  end
end

# Shunting-yard algorithm, simplified for operators of equal precedence.
def to_rpn(tokens : Enumerable(Token))
  stack = [] of LeftParen | BinaryOp
  rpn = [] of BinaryOp | Val

  tokens.each do |token|
    if token.is_a?(Val)
      rpn << token
    elsif token.is_a?(BinaryOp)
      while (top = stack.last?).is_a?(BinaryOp)
        rpn << top
        stack.pop
      end
      stack << token
    elsif token.is_a?(LeftParen)
      stack << token
    else # RightParen
      until (top = stack.pop).is_a?(LeftParen)
        rpn << top
      end
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

def eval_rpn(rpn : Enumerable(BinaryOp | Val))
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
