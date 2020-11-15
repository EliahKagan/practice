# Advent of Code 2016, day 10, parts A and B
# See filter-a and filter-b scripts for extraction and reporting.

class BotCircus
  class Error < Exception
  end

  struct ToBot
    def initialize(@id : Int32)
    end

    getter id
  end

  struct ToOut
    def initialize(@bin : Int32)
    end

    getter bin
  end

  def give(value : Int32, dest : ToBot)
    get_bot(dest.id).put(value)
  end

  def give(value : Int32, dest : ToOut)
    if @outs.has_key?(dest.bin)
      raise Error.new("can't write output bin #{dest.bin} twice")
    end

    @outs[dest.bin] = value
    puts "Output #{dest.bin}: value=#{value}"
  end

  def tell_bot(bot_id : Int32,
               low_dest : ToBot | ToOut,
               high_dest : ToBot | ToOut)
    get_bot(bot_id).subscribe_consumer do |low, high|
      give(low, low_dest)
      give(high, high_dest)
    end
  end

  private class Bot
    # Creates a new bot of the given id, subscribing the given reporter.
    # The reporter will be called as if by reporter.call(low, high) when low
    # and high have both been set (whether or not consumer has been set).
    def initialize(&@reporter : Proc(Int32, Int32, Nil))
    end

    def initialize
      @reporter = nil
    end

    # The consumer will be called as if by consumer.call(low, high) when
    # consumer, low, and high have all been set.
    def subscribe_consumer(&consumer : Proc(Int32, Int32, Nil))
      raise Error.new("can't subscribe two event handlers") if @consumer
      @consumer = consumer
      try_consume
    end

    def put(value : Int32)
      if (low = @low).nil?
        @low = value
      elsif @high.nil?
        low, high = {low, value}.minmax
        set_inputs(low, high)
      else
        raise Error.new("bot can't take a third value")
      end
    end

    private def set_inputs(low, high)
      @low = low
      @high = high
      @reporter.try &.call(low, high)
      try_consume
    end

    private def try_consume
      consumer = @consumer
      low = @low
      high = @high
      return unless consumer && low && high

      @low = @high = nil
      consumer.call(low, high)
    end

    @consumer : Proc(Int32, Int32, Nil)? = nil
    @low : Int32? = nil
    @high : Int32? = nil
  end

  private def get_bot(id)
    @bots[id] ||= Bot.new do |low, high|
      puts "Bot #{id}: low=#{low}, high=#{high}"
    end
  end

  @bots = {} of Int32 => Bot
  @outs = {} of Int32 => Int32
end

def parse_dest(dest)
  case dest
  when /^bot\s+(\d+)$/
    _, bot_id = $~
    BotCircus::ToBot.new(bot_id.to_i)
  when /^output\s+(\d+)$/
    _, output_bin = $~
    BotCircus::ToOut.new(output_bin.to_i)
  else
    raise "Unrecognized destination: #{dest}"
  end
end

circus = BotCircus.new

ARGF.each_line.map(&.strip).reject(&.empty?).each do |line|
  case line
  when /^value\s+(\d+)\s+goes\s+to\s+(.+)/
    _, value, dest = $~
    circus.give(value.to_i, parse_dest(dest))
  when /^bot\s+(\d+)\s+gives\s+low\s+to\s+(.+?)\s+and\s+high\s+to\s+(.+)/
    _, bot_id, low_dest, high_dest = $~
    circus.tell_bot(bot_id.to_i, parse_dest(low_dest), parse_dest(high_dest))
  else
    raise "Unrecognized statement: #{line}"
  end
end
