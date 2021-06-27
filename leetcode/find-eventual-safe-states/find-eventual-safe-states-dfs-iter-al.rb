# LeetCode #802 - Find Eventual Safe States
# https://leetcode.com/problems/find-eventual-safe-states/
# By iteratively implemented DFS. The state machine uses "arm's length"
# recursion (which is rarely appropriate in actual recursive code, but which
# sometimes simplifies state machines simulating recursion).

# @param {Integer[][]} graph
# @return {Integer[]}
def eventual_safe_nodes(graph)
  vis = [:white] * graph.size
  stack = []

  go = lambda do
    loop do
      frame = stack.last
      dest = frame.next_dest

      if dest.nil?
        acyclic = frame.acyclic_so_far
        vis[frame.src] = :black if acyclic
        stack.pop

        return acyclic if stack.empty?

        stack.last.acyclic_so_far &&= acyclic
      elsif vis[dest] == :white
        vis[dest] = :gray
        stack << Frame.new(graph, dest)
      elsif vis[dest] == :gray
        frame.acyclic_so_far = false
      end
    end
  end

  acyclic_from = lambda do |start|
    case vis[start]
    when :white
      vis[start] = :gray
      stack << Frame.new(graph, start)
      go.call
    when :gray
      false
    when :black
      true
    end
  end

  (0...graph.size).filter(&acyclic_from)
end

# A stack frame for iteratively implemented recursive cycle-marking DFS in a
# directed graph.
class Frame
  attr_reader :src
  attr_accessor :acyclic_so_far

  def initialize(graph, src)
    @src = src
    @row = graph[src]
    @index = 0
    @acyclic_so_far = true
  end

  def next_dest
    dest = @row[@index]
    @index += 1
    dest
  end
end
