# Advent of Code 2018, day 1, part B

deltas = ARGF.each_line.reject(&.empty?).map(&.to_i).to_a
history = Set{0}
acc = 0

loop do
  deltas.each do |delta|
    acc += delta
    if history.includes?(acc)
      puts acc
      exit
    end
    history << acc
  end
end
