# Advent of Code 2020, day 22, part B - iterative implementation

enum Action
  ReturnOrDrawCards
  PlayStartedRound
  GetRoundWinnerFromSubgameOutcome
  GiveCardsToRoundWinner
end

class Frame
  def initialize(@hand1, @hand2)
  end

  property action = Action::ReturnOrDrawCards

  def card1
    @card1 || raise "Bug: accessing uninitialized variable: card1"
  end

  def card1=(@card1 : Int32)
  end

  def card2
    @card2 || raise "Bug: accessing unintiailized variable: card2"
  end

  def card2=(@card2 : Int32)
  end

  getter history = Set(Tuple(Array(Int32), Array(Int32))).new

  getter hand1 : Array(Int32)
  getter hand2 : Array(Int32)

  @card1 : Int32? = nil
  @card2 : Int32? = nil
end

def play(initial_hand1, initial_hand2)
  stack = [Frame.new(initial_hand1, initial_hand2)] # Call stack.
  round_winner = nil # Return cell for helper procedure.
  subgame_outcome = nil # Return cell for primary procedure.

  until stack.empty?
    frame = stack.last

    case frame.action
    when Action::ReturnOrDrawCards
      if frame.hand1.empty? || frame.hand2.empty?
        if frame.hand2.empty?
          subgame_outcome = {winner: 1, hand: frame.hand1}
        else
          subgame_outcome = {winner: 2, hand: frame.hand2}
        end

        stack.pop
        next
      end

      key = {frame.hand1.dup, frame.hand2.dup}

      if frame.history.includes?(key)
        subgame_outcome = {winner: 1, hand: frame.hand1}
        stack.pop
      else
        frame.history << key
        frame.card1 = frame.hand1.shift
        frame.card2 = frame.hand2.shift
        frame.action = Action::PlayStartedRound
      end
    when Action::PlayStartedRound
      if frame.hand1.size >= frame.card1 && frame.hand2.size >= frame.card2
        subgame_hand1 = frame.hand1[...frame.card1]
        subgame_hand2 = frame.hand2[...frame.card2]
        frame.action = Action::GetRoundWinnerFromSubgameOutcome
        stack << Frame.new(subgame_hand1, subgame_hand2)
      elsif frame.card1 != frame.card2
        round_winner = (frame.card1 > frame.card2 ? 1 : 2)
        frame.action = Action::GiveCardsToRoundWinner
      else
        raise "Cards have same value, round ties are not supported."
      end
    when Action::GetRoundWinnerFromSubgameOutcome
      raise "Bug: suboutcome not written to return cell" unless subgame_outcome
      round_winner = subgame_outcome[:winner]
      subgame_outcome = nil
      frame.action = Action::GiveCardsToRoundWinner
    when Action::GiveCardsToRoundWinner
      case round_winner || raise "Bug: round winner not written to return cell"
      when 1
        frame.hand1 << frame.card1 << frame.card2
      when 2
        frame.hand2 << frame.card2 << frame.card1
      else
        raise "Bug: round winner must be player 1 or player 2."
      end

      round_winner = nil
      frame.action = Action::ReturnOrDrawCards
    else
      raise "Bug: unrecognized action: #{frame.action}"
    end
  end

  subgame_outcome || raise "Bug: outcome not written to return cell"
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
