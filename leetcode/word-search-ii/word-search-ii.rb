# LeetCode #212 - Word Search II
# https://leetcode.com/problems/word-search-ii/
# By recursive DFS.

# @param {Character[][]} board
# @param {String[]} words
# @return {String[]}
def find_words(board, words) # Note: Temporarily mutates board.
  root = build_trie(words)
  matches = Set.new
  height, width = dimensions(board)

  dfs = lambda do |i, j, node|
    return unless i.between?(0, height - 1) && j.between?(0, width - 1) &&
                  (ch = board[i][j]) && (node = node[ch])

    if (word = node[:word])
      matches << word
    end

    board[i][j] = nil

    dfs.call(i, j - 1, node)
    dfs.call(i, j + 1, node)
    dfs.call(i - 1, j, node)
    dfs.call(i + 1, j, node)

    board[i][j] = ch
  end

  0.upto(height - 1) do |i|
    0.upto(width - 1) do |j|
      dfs.call(i, j, root)
    end
  end

  matches.to_a
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
