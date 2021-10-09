# LeetCode #79 - Word Search
# https://leetcode.com/problems/word-search/

# @param {Character[][]} board
# @param {String} word
# @return {Boolean}
def exist(board, word) # Note: Temporarily mutates board.
  height, width = dimensions(board)

  dfs = lambda do |i, j, word_index|
    return true if word_index == word.size

    return false unless i.between?(0, height - 1) &&
                        j.between?(0, width - 1) &&
                        board[i][j] == word[word_index]

    board[i][j] = nil

    return true if dfs.call(i, j - 1, word_index + 1) ||
                   dfs.call(i, j + 1, word_index + 1) ||
                   dfs.call(i - 1, j, word_index + 1) ||
                   dfs.call(i + 1, j, word_index + 1)

    board[i][j] = word[word_index]

    false
  end

  0.upto(height - 1) do |i|
    0.upto(width - 1) do |j|
      return true if dfs.call(i, j, 0)
    end
  end

  false
end

def dimensions(board)
  return 0 if board.empty?

  height = board.size
  width = board.first.size
  raise 'grid is jagged' if board.any? { |row| row.size != width }

  [height, width]
end
