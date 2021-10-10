# LeetCode #127 - Word Ladder
# https://leetcode.com/problems/word-ladder/

NO_PATH = 0

# @param {String} begin_word
# @param {String} end_word
# @param {String[]} word_list
# @return {Integer}
def ladder_length(begin_word, end_word, word_list)
  return NO_PATH unless word_list.include?(end_word)

  graph = WordGraph.new(begin_word.size)
  graph.add(begin_word)
  word_list.each { |word| graph.add(word) }

  depth = graph.bfs(begin_word, end_word)
  depth ? depth + 1 : NO_PATH
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

  # Uses breadth-first search to find the distance between distinct start and
  # finish words in the word graph. Returns nil if there is no path.
  def bfs(start, finish)
    vis = Set.new([start])
    parents = {}
    queue = [start]

    (1..).each do |depth|
      break if queue.empty?

      queue.size.times do
        each_neighbor(src = queue.shift) do |dest|
          next if vis.include?(dest)

          vis << dest
          parents[dest] = src
          if dest == finish
            word = dest
            while word
              puts word
              word = parents[word]
            end
            return depth
          end
          #return depth if dest == finish

          queue << dest
        end
      end
    end

    nil
  end

  private

  def each_neighbor(src)
    src.each_masked { |masked| @groups[masked].each { |dest| yield dest } }
  end
end
