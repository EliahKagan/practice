# @param {Character[][]} board
# @param {String[]} words
# @return {String[]}
def find_words(board, words) # Note: Temporarily mutates board.
  root = build_trie(words)
  matches = Set.new
  height, width = dimensions(board)

  dfs = lambda do |i, j, node|
    word = node[:word]
    matches << word if word

    [[i, j - 1], [i, j + 1], [i - 1, j], [i + 1, j]].each do |h, k|
      if h.between?(0, height - 1) && k.between?(0, width - 1) &&
          (ch = board[h][k]) && (child = node[ch])
        board[h][k] = nil
        dfs.call(h, k, child)
        board[h][k] = ch
      end
    end
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
