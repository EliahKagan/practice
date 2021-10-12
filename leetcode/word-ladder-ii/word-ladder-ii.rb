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
    if (distance = compute_distance(start, finish))
      each_equidistant_path(start, finish, distance) { |path| yield path }
    end
  end

  private

  # Finds distance from start to finish by BFS.
  # Returns nil if there is no path.
  def compute_distance(start, finish)
    vis = Set.new([start])
    queue = [start]

    (1..).each do |depth|
      break if queue.empty?

      queue.size.times do
        each_neighbor(queue.shift) do |dest|
          next if vis.include?(dest)

          vis << dest
          return depth if dest == finish

          queue << dest
        end
      end
    end

    nil
  end

  # Yields each path from start to finish of exactly a particular distance.
  def each_equidistant_path(start, finish, distance)
    path = []

    dfs = lambda do |src|
      path << src

      if path.size == distance + 1
        yield path.dup if src == finish
      else
        each_neighbor(src, &dfs)
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
