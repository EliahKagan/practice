# https://www.hackerrank.com/challenges/kundu-and-tree

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

PERIOD = 1_000_000_007_i64

def count_triples(sizes)
  singles = pairs = triples = 0i64

  sizes.each do |size|
    triples = (triples + pairs * size) % PERIOD
    pairs = (pairs + singles * size) % PERIOD
    singles = (singles + size) % PERIOD
  end

  triples
end

n = gets.as(String).to_i
elems = (0..n).map { Element.new } # extra vertex for 1-based indexing

(n - 1).times do
  u, v, color = gets.as(String).split
  if color == "b"
    elems[u.to_i].union(elems[v.to_i])
  elsif color != "r"
    raise %(Color "#{color}" is neither red ("r") nor black ("b").)
  end
end

puts count_triples(elems.each.skip(1).map(&.size).reject(&.zero?))
