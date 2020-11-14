# Advent of Code 2016, day 10, part A

class BotCircus
  class Error < Exception
  end

  private struct Bot
    @action : Proc(Int32, Int32, Int32, Nil)? = nil
    @low : Int32? = nil
    @high : Int32? = nil

    def initialize(@id : Int32)
    end

    # The action will be called as if by action.call(id, low, high).
    def subscribe(&action : Proc(Int32, Int32, Int32, Nil))
      raise Error.new("can't subscribe two event handlers") if @action
      @action = action
      maybe_run
    end

    def put(value : Int32)
      low = @low
      if low.nil?
        @low = value
      elsif @high.nil
        @low, @high = {low, value}.minmax
        maybe_run
      else
        raise Error.new("bot can't take a third value")
      end
    end

    private def maybe_run
      action = @action
      low = @low
      high = @high
      return unless action && low && high

      @low = @high = nil
      action.call(@id, low, high)
    end

  end
end
