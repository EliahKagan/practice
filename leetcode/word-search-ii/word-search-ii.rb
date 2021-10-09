# LeetCode #212 - Word Search II
# https://leetcode.com/problems/word-search-ii/
# By recursive DFS.

# @param {Character[][]} board
# @param {String[]} words
# @return {String[]}
def find_words(board, words) # Note: Temporarily mutates board.
  possible = possible_words(board, words)
  puts "#{possible.size} possible word(s)."
  root = build_trie(possible_words(board, words))
  #p root.values.map { |node| node.key?(:population) }
  pp root
  #pp root
  #puts "Trie population of #{root.each_value.sum { |node| node[:population] || 0 }}."
  matches = []
  height, width = dimensions(board)

  # Returns the number of trie words under the node that were found.
  dfs = lambda do |i, j, parent|
    return 0 unless i.between?(0, height - 1) && j.between?(0, width - 1) &&
                    (ch = board[i][j]) && (child = parent[ch])

    count = 0

    if (word = child[:word])
      matches << word
      child.delete(:word)
      count += 1

      if (child[:population] -= 1).zero?
        #puts "Found last word, deleting '#{ch}' node. Parent was:"
        #puts parent
        parent.delete(ch)
        return count
      end
    end

    board[i][j] = nil

    [[i, j - 1], [i, j + 1], [i - 1, j], [i + 1, j]].each do |h, k|
      subcount = dfs.call(h, k, child)
      next if subcount.zero? # A simple optimization.

      count += subcount

      if (child[:population] -= subcount).zero?
        parent.delete(ch)
        break
      end
    end

    board[i][j] = ch

    count
  end

  0.upto(height - 1) do |i|
    0.upto(width - 1) do |j|
      dfs.call(i, j, root)
    end
  end

  matches
end

def possible_words(board, words)
  board_letters = board.flatten(1).to_set()

  words.filter do |word|
    word.each_char.all? { |ch| board_letters.include?(ch) }
  end
end

def build_trie(words)
  root = {}

  words.each do |word|
    parent = root

    word.each_char do |ch|
      if (child = parent[ch])
        child[:population] += 1
      else
        child = {population: 1}
        parent[ch] = child
      end

      parent = child
    end

    parent[:word] = word
  end

  root
end

def dimensions(board)
  return 0 if board.empty?

  height = board.size
  width = board.first.size
  raise 'grid is jagged' if board.any? { |row| row.size != width }

  [height, width]
end
