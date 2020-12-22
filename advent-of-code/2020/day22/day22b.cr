# Advent of Code 2020, day 22, part B

def play(hand1, hand2)
  if hand1.empty? || hand2.empty?
    raise "Games with empty hands are not supported."
  end

  history = Set(Tuple(Array(Int32), Array(Int32))).new

  until hand1.empty? || hand2.empty?
    key = {hand1.dup, hand2.dup}
    return {winner: 1, hand: hand1} if history.includes?(key)
    history << key

    card1 = hand1.shift
    card2 = hand2.shift

    case round_winner(hand1, hand2, card1, card2)
    when 1
      hand1 << card1 << card2
    when 2
      hand2 << card2 << card1
    else
      raise "Bug: round winner must be player 1 or player 2."
    end
  end

  if hand2.empty?
    {winner: 1, hand: hand1}
  else
    {winner: 2, hand: hand2}
  end
end

def round_winner(hand1, hand2, card1, card2)
  if hand1.size >= card1 && hand2.size >= card2
    outcome = play(hand1[...card1], hand2[...card2])
    outcome[:winner]
  elsif card1 > card2
    1
  elsif card1 < card2
    2
  else
    raise "Cards have same value, round ties are not supported."
  end
end

hand1, hand2 = ARGF.each_line("\n\n")
  .map(&.strip.each_line.skip(1).map(&.to_i).to_a)
  .to_a

outcome = play(hand1, hand2)

winning_score = outcome[:hand]
	.reverse
	.each_with_index(1)
	.sum { |value, index| value * index }

puts winning_score
