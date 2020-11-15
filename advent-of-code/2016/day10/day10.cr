# Advent of Code 2016, day 10, part A

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
  end

  def tell_bot(bot_id : Int32,
               low_dest : ToBot | ToOut,
               high_dest : ToBot | ToOut)
    get_bot[bot_id].subscribe_consumer do |low, high|
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

    @consumer : Proc(Int32, Int32, Int32, Nil)? = nil
    @low : Int32? = nil
    @high : Int32? = nil
  end

  private def get_bot(id)
    @bots[id] ||= Bot.new { |low, high| "Bot #{id}: low=#{low}, high=#{high}" }
  end

  @bots = {} of Int32 => Bot
  @outs = {} of Int32 => Int32
end
