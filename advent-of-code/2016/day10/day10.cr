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

  private class Bot
    def initialize(@id : Int32)
    end

    # The reporter will be called as if by reporter.call(id, low, high) when
    # low and high have both been set (whether or not consumer has been set).
    def subscribe_reporter(&reporter: Proc(Int32, Int32, Int32, Nil))
      raise Error.new("can't subscribe two reporters") if @reporter
      @reporter = reporter
    end

    # The consumer will be called as if by consumer.call(id, low, high) when
    # consumer, low, and high have all been set.
    def subscribe_consumer(&consumer : Proc(Int32, Int32, Int32, Nil))
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
      @reporter.try &.call(@id, low, high)
      try_consume
    end

    private def try_consume
      consumer = @consumer
      low = @low
      high = @high
      return unless consumer && low && high

      @low = @high = nil
      consumer.call(@id, low, high)
    end

    @reporter : Proc(Int32, Int32, Int32, Nil)? = nil
    @consumer : Proc(Int32, Int32, Int32, Nil)? = nil
    @low : Int32? = nil
    @high : Int32? = nil
  end

  @bots = {} of Bot
  @outs = {} of Int32
end
