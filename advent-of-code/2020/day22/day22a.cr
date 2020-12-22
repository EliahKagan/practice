# Advent of Code 2020, day 22, part A

hand1, hand2 = ARGF.each_line("\n\n")
  .map(&.strip.each_line.skip(1).map(&.to_i).to_a)
  .to_a

raise "hands overlap" unless (Set.new(hand1) & Set.new(hand2)).empty?

until hand1.empty? || hand2.empty?
  card1 = hand1.shift
  card2 = hand2.shift

  if card1 > card2
    hand1 << card1 << card2
  else
    hand2 << card2 << card1
  end
end

winning_score = (hand2.empty? ? hand1 : hand2)
  .reverse!
  .each_with_index(1)
  .sum { |value, index| value * index }

puts winning_score
