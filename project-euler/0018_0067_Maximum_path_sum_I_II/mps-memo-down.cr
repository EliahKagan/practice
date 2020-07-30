# A trianguar grid maximum path sum problem instance (solving downward).
class Grid
  @elems : Array(Array(Int32))
  @memo : Array(Array(Int32?))

  def initialize(io)
    @elems = io.each_line.map(&.split.map(&.to_i)).to_a
    raise "wrong grid shape" unless correct_shape?
    
    @memo = (1..@elems.size).map { |width| Array(Int32?).new(width, nil) }
    @memo[0][0] = @elems[0][0]
  end

  def solve
    i = @elems.size - 1
    (0..i).max_of { |j| solve_dest(i, j) }
  end

  private def solve_dest(i, j)
    @memo[i][j] ||= do_solve_dest(i, j)
  end

  private def do_solve_dest(i, j)
    sum_above =
      if j.zero?
        solve_dest(i - 1, j)
      elsif j == i
        solve_dest(i - 1, j - 1)
      else
        Math.max(solve_dest(i - 1, j - 1), solve_dest(i - 1, j))
      end

    @elems[i][j] + sum_above
  end

  private def correct_shape?
    @elems.each_with_index(1).all? { |row, count| row.size == count }
  end
end

puts Grid.new(ARGF).solve
