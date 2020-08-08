# A trigangular grid maximum path sum problem instance.
class Grid
  @elems : Array(Array(Int32))
  @memo : Array(Array(Int32?))

  def initialize(io)
    @elems = io.each_line.map(&.split.map(&.to_i)).to_a
    raise "wrong grid shape" unless correct_shape?
    @memo = (1..@elems.size).map { |width| Array(Int32?).new(width, nil) }
  end

  def solve(i, j)
    return 0 if i == @elems.size

    @memo[i][j] ||=
      @elems[i][j] + Math.max(solve(i + 1, j), solve(i + 1, j + 1))
  end

  private def correct_shape?
    @elems.each_with_index(1).all? { |row, count| row.size == count }
  end
end

puts Grid.new(ARGF).solve(0, 0)
