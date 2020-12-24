# Advent of Code 2020, day 23, part B

require "option_parser"

MIN_CUP = 1
MAX_CUP = 10**6
HANDFUL = 3
DEFAULT_GAME_LENGTH = 10**7

class Node(T)
  include Enumerable(T)

  getter value : T
  getter left : Node(T)
  getter right : Node(T)

  def initialize(@value : T)
    # Pretend to inititialize @left and @right so the compiler gives us self.
    @left = uninitialized(Node(T))
    @right = uninitialized(Node(T))

    # Make this node a singleton list.
    @left = @right = self
  end

  def each(&block)
    node = self
    loop do
      yield node.value
      node = node.right
      break if node == self
    end
  end

  def splice_in(other : Node(T))
    other.left.connect(@right)
    connect(other)
    nil
  end

  def splice_out(start : Int32, count : Int32)
    raise "start index #{start} is negative" if start < 0
    raise "count #{count} is not (strictly) positive" if count <= 0

    # Find the subchain to splice out.
    initial = hop_right(start)
    final = initial.hop_right(count - 1)

    # Make the rest of the original chain a loop without it.
    initial.left.connect(final.right)

    # Make the removed subchain a loop.
    final.connect(initial)

    initial
  end

  protected setter left, right

  protected def hop_right(distance : Int32)
    raise "distance #{distance} is negative" if distance < 0

    node = self
    distance.times { node = node.right }
    node
  end

  protected def connect(new_right : Node(T))
    @right = new_right
    new_right.left = self
    nil
  end
end

def read_custom_cup_values
  custom_values = ARGF.gets_to_end.strip.chars.map(&.to_i)

  unless custom_values.sort == (MIN_CUP..custom_values.max).to_a
    raise "custom cups are nonconsective or missing leading values"
  end

  custom_values
end

def with_remaining_cup_values(custom_values)
  first_remaining = (custom_values.empty? ? MIN_CUP : custom_values.max + 1)
  remaining_values = first_remaining..MAX_CUP
  custom_values.each.chain(remaining_values.each)
end

def build_initial_cup_chain(cups, values)
  values.each_cons_pair do |left_value, right_value|
    cups[left_value].splice_in(cups[right_value])
  end
end

def read_initial_state
  custom_values = read_custom_cup_values
  cups = Array(Node(Int32)).new(MAX_CUP + 1) { |value| Node.new(value) }
  build_initial_cup_chain(cups, with_remaining_cup_values(custom_values))
  major = cups[custom_values.first? || MIN_CUP]

  expected_range = (MIN_CUP..MAX_CUP).to_a
  unless cups.skip(MIN_CUP).map(&.value).to_a.sort! == expected_range
    raise "Bug: the expanded sequence of cup values is incorrect"
  end
  unless major.to_a.sort! == expected_range
    raise "Bug: the linked list of cups was not build correctly"
  end

  {cups, major}
 end

def predecessor(cup_value)
  cup_value == MIN_CUP ? MAX_CUP : cup_value - 1
end

game_length = DEFAULT_GAME_LENGTH
verbose = false

OptionParser.parse do |parser|
  parser.on "-c COUNT", "--count=COUNT", "number of moves to take" do |count|
    game_length = count.to_i
  end
  parser.on "-v", "--verbose", "show values that multiply to the solution" do
    verbose = true
  end
  parser.on "-h", "--help", "show options help" do
    puts parser
    exit
  end
end

cups, major = read_initial_state

game_length.times do
  # Pick a handful of cups immediately clockwise of the current cup.
  minor = major.splice_out(1, HANDFUL)
  hand = minor.to_a

  # Select a destination cup.
  dest_value = predecessor(major.value)
  while hand.includes?(dest_value)
    dest_value = predecessor(dest_value)
  end

  # Place the picked up cups immediately clockwise of the destination cup.
  cups[dest_value].splice_in(minor)

  # Select the new current cup.
  major = major.right
end

min_node = cups[MIN_CUP]
value1 = min_node.right.value
value2 = min_node.right.right.value
puts "The two cups after #{MIN_CUP} are #{value1} and #{value2}." if verbose
puts value1.to_i64 * value2.to_i64
