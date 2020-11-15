# Advent of Code 2016, day 12, part A

class Emulator
  class Error < Exception
  end

  def <<(instruction : String)
    @program << translate(instruction)
  end

  def run
    while 0 <= @pos < @program.size
      @program[@pos].call
      @pos += 1
    end

    raise Error.new("negative instruction pointer not supported") if @pos < 0
  end

  def read_register(name : String)
    @registers[name]
  end

  private def translate(instruction)
    tokens = instruction.split

    case tokens.size
    when 2
      op, arg = tokens
      translate_unary(op, arg)
    when 3
      op, arg1, arg2 = tokens
      translate_binary(op, arg1, arg2)
    else
      raise Error.new("wrong record length for instruction")
    end
  end

  private def translate_unary(unary_op, arg) : Proc(Nil)
    case unary_op
    when "inc"
      delta = 1
    when "dec"
      delta = -1
    else
      raise Error.new("unrecognized unary operation: #{unary_op}")
    end

    check_register(arg)
    ->{ @registers[arg] += delta }
  end

  private def translate_binary(binary_op, arg1, arg2) : Proc(Nil)
    case binary_op
    when "cpy"
      translate_cpy_instruction(arg1, arg2)
    when "jnz"
      translate_jnz_instruction(arg1, arg2)
    else
      raise Error.new("unrecognized binary operation: #{binary_op}")
    end
  end

  private def translate_cpy_instruction(src_arg, dest_arg) : Proc(Nil)
    src_getter = make_getter(src_arg)
    check_register(dest_arg)

    ->{ @registers[dest_arg] = src_getter.call }
  end

  private def translate_jnz_instruction(condition_arg, offset_arg) : Proc(Nil)
    condition_getter = make_getter(condition_arg)
    offset_getter = make_getter(offset_arg)
    
    # Make code to jump _before_ the destination, as @pos will be incremented.
    ->{ @pos += offset_getter.call - 1 unless condition_getter.call.zero? }
  end

  private def make_getter(arg) : Proc(Int32)
    if constant = arg.to_i?
      copy = constant # Because captured variables' types are not nil-traced.
      -> { copy }
    else
      check_register(arg)
      ->{ @registers[arg] }
    end
  end

  private def check_register(register_arg)
    unless @registers.has_key?(register_arg)
      raise Error.new("unrecognized register name: #{register_arg}")
    end
  end

  @program = [] of Proc(Nil)
  @registers = {"a" => 0, "b" => 0, "c" => 0, "d" => 0}
  @pos = 0
end
