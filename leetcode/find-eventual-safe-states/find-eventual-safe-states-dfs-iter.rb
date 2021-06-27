# LeetCode #802 - Find Eventual Safe States
# https://leetcode.com/problems/find-eventual-safe-states/
# By iteratively implemented DFS. The state machine implements the same logic as
# in find-eventual-safe-states-dfs-rec.rb.

# @param {Integer[][]} graph
# @return {Integer[]}
def eventual_safe_nodes(graph)
  vis = [:white] * graph.size

  acyclic_from = lambda do |start|
    acyclic = nil
    stack = [Frame.new(start)]

    until stack.empty?
      frame = stack.last

      case frame.state
      when :check
        case vis[frame.src]
        when :white
          vis[frame.src] = :gray
          frame.state = :dispatch
        when :gray
          acyclic = false
          stack.pop
        when :black
          acyclic = true
          stack.pop
        end

      when :dispatch
        if (dest = graph[frame.src][frame.index])
          frame.state = :collect
          stack << Frame.new(dest)
        else
          acyclic = frame.acyclic_so_far
          vis[frame.src] = :black if acyclic
          stack.pop
        end

      when :collect
        frame.acyclic_so_far &&= acyclic
        frame.index += 1
        frame.state = :dispatch

      else
        raise "unrecognized state: #{frame.state}"
      end
    end

    acyclic
  end

  (0...graph.size).filter(&acyclic_from)
end

# A stack frame for iteratively implemented recursive cycle-marking DFS in a
# directed graph.
class Frame
  attr_reader :src
  attr_accessor :index
  attr_accessor :acyclic_so_far
  attr_accessor :state

  def initialize(src)
    @src = src
    @index = 0
    @acyclic_so_far = true
    @state = :check
  end
end
