class Element
  protected property parent
  protected property size = 1

  def initialize
    @parent = self
  end

  def cardinality
    root.size
  end

  def union(other : Element)
    # Find the ancestors and stop if they are the same.
    root1 = root
    root2 = other.root
    return if root1 == root2

    # Unite the sets by size.
    if root1.size < root2.size
      root2.adopt_child(root1)
    else
      root1.adopt_child(root2)
    end
  end

  protected def root
    @parent = @parent.root if @parent != self
    @parent
  end

  protected def adopt_child(child)
    @size += child.size
    child.parent = self
    nil
  end
end

def read_tokens
  gets.as(String).split
end

element_count, query_count = read_tokens.map(&.to_i)
elements = (0..element_count).map { Element.new } # extra for 1-based indexing

query_count.times do
  tokens = read_tokens
  case tokens[0]
  when "M"
    elements[tokens[1].to_i].union(elements[tokens[2].to_i])
  when "Q"
    puts elements[tokens[1].to_i].cardinality
  else
    raise %(Unrecognized operation "#{tokens[0]}")
  end
end
