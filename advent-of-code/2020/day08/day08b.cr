# Advent of Code 2020, day 8, part B

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

  def initialize(@opcode, @argument)
  end

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

  def with_opcode(opcode : Opcode)
    Instruction.new(opcode, @argument)
  end
end

enum Status
  NotStarted
  Running
  Completed
  IllegalJump
  InfiniteLoop
end

class Emulator
  getter status = Status::NotStarted
  getter acc = 0

  def initialize(io)
    @code = io.each_line
      .map(&.strip)
      .reject(&.empty?)
      .map { |line| Instruction.new(line) }
      .to_a

    raise ArgumentError.new("empty program not supported") if @code.empty?

    @vis = BitArray.new(@code.size)
    @pos = 0
  end

  def size
    @code.size
  end

  def [](index)
    @code[index]
  end

  def []=(index, instruction)
    @code[index] = instruction
  end

  def next?
    if @vis[@pos]
      @status = Status::InfiniteLoop
      return false
    end
    @vis[@pos] = true

    case @code[@pos].opcode
    when Opcode::Acc
      @acc += @code[@pos].argument
      @pos += 1
    when Opcode::Jmp
      @pos += @code[@pos].argument
    when Opcode::Nop
      @pos += 1
    else
      raise "Bug: unrecognized opcode (should have been detected before)"
    end

    unless 0 <= @pos < @code.size
      @status = (@pos == @code.size ? Status::Completed : Status::IllegalJump)
      return false
    end

    @status = Status::Running
    return true
  end

  def reset
    @status = Status::NotStarted
    @vis = BitArray.new(@code.size)
    @pos = 0
    @acc = 0
  end

  @code : Array(Instruction)
end

emulator = Emulator.new(ARGF)

0.upto(emulator.size - 1) do |index|
  old_instruction = emulator[index]

  case old_instruction.opcode
  when Opcode::Acc
    next
  when Opcode::Jmp
    new_opcode = Opcode::Nop
  when Opcode::Nop
    new_opcode = Opcode::Jmp
  else
    raise "Bug: unrecognized opcode obtained from emulator"
  end

  emulator[index] = old_instruction.with_opcode(new_opcode)

  while emulator.next?
  end

  if emulator.status == Status::Completed
    puts emulator.acc
    exit 0
  end

  emulator.reset
  emulator[index] = old_instruction
end

STDERR.puts "#{PROGRAM_NAME}: error: no successful repair found"
exit 1
