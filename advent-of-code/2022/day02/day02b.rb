#!/usr/bin/env ruby
# frozen_string_literal: true

# Advent of Code 2022, day 2, part B

$VERBOSE = true

DECODE_PLAY = {
  'A' => :rock,
  'B' => :paper,
  'C' => :scissors
}.freeze

DECODE_OUTCOME = {
  'X' => :lose,
  'Y' => :draw,
  'Z' => :win
}.freeze

# (opponent play, desired outcome) -> our play
COUNTER_PLAY = {
  %i[rock lose].freeze => :scissors,
  %i[rock draw].freeze => :rock,
  %i[rock win].freeze => :paper,
  %i[paper lose].freeze => :rock,
  %i[paper draw].freeze => :paper,
  %i[paper win].freeze => :scissors,
  %i[scissors lose].freeze => :paper,
  %i[scissors draw].freeze => :scissors,
  %i[scissors win].freeze => :rock
}.freeze

PLAY_SCORE = {
  rock: 1,
  paper: 2,
  scissors: 3
}.freeze

OUTCOME_SCORE = {
  lose: 0,
  draw: 3,
  win: 6
}.freeze

# Compute the score for a round of rock-paper-scissors.
def score_round(opponent_play_code, outcome_code)
  opponent_play = DECODE_PLAY[opponent_play_code]
  outcome = DECODE_OUTCOME[outcome_code]
  counter_play = COUNTER_PLAY[[opponent_play, outcome]]
  PLAY_SCORE[counter_play] + OUTCOME_SCORE[outcome]
end

def run
  total = ARGF.map(&:strip)
              .reject(&:empty?)
              .map(&:split)
              .sum { |codes| score_round(*codes) }

  puts total
end

run if $PROGRAM_NAME == __FILE__
