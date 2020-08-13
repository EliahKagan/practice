# https://www.hackerrank.com/challenges/find-the-running-median
# With a maxheap of lower values and a minheap of higher values.

# Signals an invalid operation on a PriorityQueue.
class PriorityQueueError < IndexError
end

# A priority queue implemented as a binary heap. With <=>, this is a minheap.
class PriorityQueue(T)
  def self.make_minheap
    PriorityQueue(T).new { |ls, rs| ls <=> rs }
  end

  def self.make_maxheap
    PriorityQueue(T).new { |ls, rs| rs <=> ls }
  end

  @elems = [] of T

  def initialize(&@comparer : T, T -> Int32)
  end

  def empty?
    @elems.empty?
  end

  def size
    @elems.size
  end

  def push(key : T)
    @elems << key
    sift_up(size - 1)
  end

  def top
    @elems[0]
  rescue IndexError
    raise PriorityQueueError.new("can't read top of empty priority queue")
  end

  def pop
    ret = top
    if @elems.one?
      @elems.clear
    else
      @elems[0] = @elems.pop
      sift_down(0)
    end
    ret
  end

  private def sift_up(child)
    until child.zero?
      parent = (child - 1) // 2
      break if order_ok?(parent, child)
      @elems.swap(parent, child)
      child = parent
    end
  end

  private def sift_down(parent)
    loop do
      child = pick_child(parent)
      break if child.nil? || order_ok?(parent, child)
      @elems.swap(parent, child)
      parent = child
    end
  end

  private def pick_child(parent)
    left = parent * 2 + 1
    return nil if left >= size
    right = left + 1
    right == size || order_ok?(left, right) ? left : right
  end

  private def order_ok?(parent, child)
    @comparer.call(@elems[parent], @elems[child]) <= 0
  end
end

class MedianBag
  @lows = PriorityQueue(Int32).make_maxheap
  @highs = PriorityQueue(Int32).make_minheap

  def push(value : Int32)
    if @highs.empty? || value < @highs.top
      @lows.push(value)
    else
      @highs.push(value)
    end
    rebalance
  end

  def median
    case balance_factor
    when -1
      @lows.top.to_f
    when 0
      (@lows.top + @highs.top) / 2
    when +1
      @highs.top.to_f
    else
      raise "Bug: balancing invariant violated"
    end
  end

  private def rebalance
    case balance_factor
    when -2
      @highs.push(@lows.pop)
    when +2
      @lows.push(@highs.pop)
    end
  end

  private def balance_factor
    @highs.size - @lows.size
  end
end

def read_value
  gets.as(String).to_i
end

bag = MedianBag.new

read_value.times do
  bag.push(read_value)
  printf "%.1f\n", bag.median
end
