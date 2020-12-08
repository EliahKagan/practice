# Advent of Code 2020, day 8, part A

require "bit_array"

enum Opcode
  Acc
  Jmp
  Nop
end

struct Instruction
  class Error < ArgumentError
    def initialize(reason)
      super("bad instruction: #{reason}")
    end
  end

  getter opcode : Opcode
  getter argument : Int32

  def initialize(line : String)
    tokens = line.split
    raise Error.new("need 2 tokens, got #{tokens.size}") if tokens.size != 2

    opcode_tok, arg_tok = tokens

    @opcode =
      case opcode_tok
      when "acc"
        Opcode::Acc
      when "jmp"
        Opcode::Jmp
      when "nop"
        Opcode::Nop
      else
        raise Error.new(%Q{unknown opcode "#{opcode_tok}"})
      end

    @argument =
      begin
        arg_tok.to_i
      rescue e : ArgumentError
        raise Error.new(e.message)
      end
  end
end

class Emulator
  class Error < Exception
  end

  @code : Array(Instruction)
  @pos = 0

  getter acc = 0

  def initialize(io)
    @code = io.each_line
      .map(&.strip)
      .reject(&.empty?)
      .map { |line| Instruction.new(line) }
      .to_a

    raise Error.new("empty program not supported") if @code.empty?

    @vis = BitArray.new(@code.size)
  end

  def next?
    return false if @vis[@pos]

    newpos = @pos
    newacc = @acc

    case @code[@pos].opcode
    when Opcode::Acc
      newacc += @code[@pos].argument
      newpos += 1
    when Opcode::Jmp
      newpos += @code[@pos].argument
    when Opcode::Nop
      newpos += 1
    else
      raise "Bug: unrecognized opcode (should have been detected before)"
    end

    unless 0 <= newpos < @code.size
      raise Error.new("Program counter would go out of range")
    end

    @vis[@pos] = true
    @pos = newpos
    @acc = newacc
    true
  end
end

emulator = Emulator.new(ARGF)
acc = 0

loop do
  acc = emulator.acc
  break unless emulator.next?
end

puts acc
