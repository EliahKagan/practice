# LeetCode #126 - Word Ladder II
# https://leetcode.com/problems/word-ladder-ii/
# BFS to find distance, then recursive DFS to enumerate paths.

# @param {String} begin_word
# @param {String} end_word
# @param {String[]} word_list
# @return {String[][]}
def find_ladders(begin_word, end_word, word_list)
  return [] unless word_list.include?(end_word)

  graph = WordGraph.new(begin_word.size)
  graph.add(begin_word)
  word_list.each { |word| graph.add(word) }

  paths = []
  graph.each_shortest_path(begin_word, end_word) { |path| paths << path }
  paths
end

# Extension to mask out single characters in a string.
class String
  def each_masked
    0.upto(size - 1) { |i| yield "#{self[...i]}\0#{self[(i + 1)..]}" }
  end
  nil
end

# An implicit graph on word groupings by single-character deletion.
class WordGraph
  # Creates a word graph for words of a specified width (i.e., size, length).
  def initialize(width)
    @width = width
    @groups = Hash.new { |h, x| h[x] = [] }
  end

  # Adds a word to the word graph.
  def add(word)
    raise 'wrong length word' if word.size != @width

    word.each_masked { |masked| @groups[masked] << word }
  end

  def each_shortest_path(start, finish)
    if (depths = compute_depths(start, finish))
      each_path(start, finish, depths) { |path| yield path }
    end
  end

  private

  # Finds distances to vertices by BFS, except those farther than the target.
  # If the target (finish) vertex is not found, returns nil.
  def compute_depths(start, finish)
    finish_depth = nil
    depths = {start => 0}
    queue = [start]

    until queue.empty?
      src = queue.shift
      break if depths[src] == finish_depth

      next_depth = depths[src] + 1

      each_neighbor(src) do |dest|
        next if depths.key?(dest)

        depths[dest] = next_depth
        finish_depth = depths[dest] if dest == finish
        queue << dest
      end
    end

    finish_depth ? depths : nil
  end

  # Using the results of BFS, does DFS to find each shortest path to a target.
  def each_path(start, finish, depths)
    path = []

    dfs = lambda do |src|
      path << src

      if src == finish
        yield path.dup
      else
        next_depth = depths[src] + 1

        each_neighbor(src) do |dest|
          dfs.call(dest) if depths[dest] == next_depth
        end
      end

      path.pop
    end

    dfs.call(start)
    nil
  end

  def each_neighbor(src)
    src.each_masked { |masked| @groups[masked].each { |dest| yield dest } }
  end
end
