# Advent of Code 2020, day 23, part A - implementation using a linked list

require "option_parser"

MIN_CUP = 1
MAX_CUP = 9
HANDFUL = 3
DEFAULT_GAME_LENGTH = 100

class Node(T)
  include Enumerable(T)

  getter value : T
  property left : Node(T)
  property right : Node(T)

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

  def connect(new_right : Node(T))
    @right = new_right
    new_right.left = self
    nil
  end

  def splice_out(start : Int32, count : Int32)
    raise "start index #{start} is negative" if start < 0
    raise "count #{count} is not (strictly) positive" if count <= 0

    # Find the subchain to splice out.
    initial = hop_right(start)
    final = initial.hop_right(count - 1)

    # Make the rest of the original chain a loop without it.
    initial.left.right = final.right
    final.right.left = initial.left

    # Make the removed subchain a loop.
    initial.left = final
    final.right = initial

    initial
  end

  def splice_in(other : Node(T))
    other.left.right = @right
    @right.left = other.left
    @right = other
    other.left = self
    nil
  end

  protected def hop_right(distance : Int32)
    raise "distance #{distance} is negative" if distance < 0

    node = self
    distance.times { node = node.right }
    node
  end
end

def read_cup_values
  values = ARGF.gets_to_end.strip.chars.map(&.to_i)

  unless values.sort == (MIN_CUP..MAX_CUP).to_a
    raise "missing or duplicate cups"
  end

  values
end

def connect_initial_cups(cups, values)
  values.each_cons_pair do |left_value, right_value|
    cups[left_value].connect(cups[right_value])
  end

  cups[values.last].connect(cups[values.first])
end

def read_initial_state
  values = read_cup_values
  cups = Array(Node(Int32)).new(MAX_CUP + 1) { |value| Node.new(value) }
  connect_initial_cups(cups, values)
  {cups, cups[values.first]}
 end

def predecessor(cup_value)
  cup_value == MIN_CUP ? MAX_CUP : cup_value - 1
end

game_length = DEFAULT_GAME_LENGTH

OptionParser.parse do |parser|
  parser.on "-c COUNT", "--count=COUNT" do |count|
    game_length = count.to_i
  end
  parser.on "-h", "--help" do
    puts parser
    exit
  end
end

cups, major = read_initial_state
# FIXME: remove after debugging:
#cups.each { |node| puts "#{node.left.value} -> #{node.value} -> #{node.right.value}" }

game_length.times do
  # Pick a handful of cups immediately clockwise of the current cup.
  minor = major.splice_out(1, HANDFUL)
  hand = minor.to_a

  # FIXME: remove after debugging
  STDERR.puts "DEBUG: major: #{major.to_a} minor: #{hand}"

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

puts cups[MIN_CUP].skip(1).join
