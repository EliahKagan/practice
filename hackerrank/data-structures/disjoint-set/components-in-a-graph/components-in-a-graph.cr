# https://www.hackerrank.com/challenges/components-in-graph

# An element of a set, for union-find.
class Element
  protected property parent
  getter size
  protected setter size = 1

  def initialize
    @parent = self
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
    child.size = 0
    child.parent = self
    nil
  end
end

n = gets.as(String).to_i
elements = Array(Element).new(n * 2 + 1) { Element.new } # 1-based indexing

n.times do
  i, j = gets.as(String).split.map(&.to_i)
  elements[i].union(elements[j])
end

min, max = elements.map(&.size).select { |size| size > 1 }.minmax
puts "#{min} #{max}"
