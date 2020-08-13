# https://www.hackerrank.com/challenges/contacts

# A trie for prefix counting. Does not keep track of where words end.
class Trie
  # A trie node. Each node instance represents a prefix.
  private class Node
    @children = {} of Char => Node
    property count = 0

    def [](ch)
      @children[ch]
    end

    def []?(ch)
      @children[ch]?
    end

    def []=(ch, node)
      @children[ch] = node
    end
  end

  @root = Node.new

  # Adds *word* as a chain to the trie, incrementing all its prefixes' counts.
  def add(word)
    node = @root
    word.each_char do |ch|
      node.count += 1
      node = node[ch] ||= Node.new
    end
    node.count += 1
  end

  # Counts the number of times a chain with prefix *prefix* was added.
  def count(prefix)
    node = @root
    prefix.each_char do |ch|
      node = node[ch]?
      return 0 if node.nil?
    end
    node.count
  end
end

trie = Trie.new

gets.as(String).to_i.times do
  command, argument = gets.as(String).split

  case command
  when "add"
    trie.add(argument)
  when "find"
    puts trie.count(argument)
  else
    raise "Unrecognized command: #{command}"
  end
end
