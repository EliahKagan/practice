# LeetCode #212 - Word Search II
# https://leetcode.com/problems/word-search-ii/
# By recursive DFS.

# @param {Character[][]} board
# @param {String[]} words
# @return {String[]}
def find_words(board, words) # Note: Temporarily mutates board.
  root = build_trie(possible_words(board, words))
  matches = []
  height, width = dimensions(board)

  dfs = lambda do |i, j, parent|
    return unless i.between?(0, height - 1) && j.between?(0, width - 1) &&
                  (ch = board[i][j]) && (child = parent[ch])

    if (word = child[:word])
      matches << word
      child.delete(:word)
      if child.empty?
        parent.delete(ch)
        return
      end
    end

    board[i][j] = nil

    [[i, j - 1], [i, j + 1], [i - 1, j], [i + 1, j]].each do |h, k|
      dfs.call(h, k, child)
      if child.empty?
        parent.delete(ch)
        break
      end
    end

    board[i][j] = ch
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
    node = root
    word.each_char { |ch| node = node[ch] ||= {} }
    node[:word] = word
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
