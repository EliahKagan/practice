# LeetCode #208 - Implement Trie (Prefix Tree)

class Trie
  def initialize()
    @root = {}
  end

=begin
  :type word: String
  :rtype: Void
=end
  def insert(word)
    node = @root
    word.each_char { |ch| node = node[ch] ||= {} }
    node[:word] = true
    nil
  end

=begin
  :type word: String
  :rtype: Boolean
=end
  def search(word)
    !!traverse(word)&.dig(:word)
  end

=begin
  :type prefix: String
  :rtype: Boolean
=end
  def starts_with(prefix)
    !!traverse(prefix)
  end

  private

  def traverse(prefix)
    node = @root
    prefix.each_char { |ch| break unless (node = node[ch]) }
    node
  end
end

# Your Trie object will be instantiated and called as such:
# obj = Trie.new()
# obj.insert(word)
# param_2 = obj.search(word)
# param_3 = obj.starts_with(prefix)
