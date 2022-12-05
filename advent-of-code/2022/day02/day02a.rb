#!/usr/bin/env ruby
# frozen_string_literal: true

# Advent of Code 2022, day 2, part A

$VERBOSE = true

DECODE = {
  'A' => :rock,
  'B' => :paper,
  'C' => :scissors,
  'X' => :rock,
  'Y' => :paper,
  'Z' => :scissors
}.freeze

OUTCOME = {
  %i[rock rock].freeze => :draw,
  %i[rock paper].freeze => :win,
  %i[rock scissors].freeze => :lose,
  %i[paper rock].freeze => :lose,
  %i[paper paper].freeze => :draw,
  %i[paper scissors].freeze => :win,
  %i[scissors rock].freeze => :win,
  %i[scissors paper].freeze => :lose,
  %i[scissors scissors].freeze => :draw
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
def score_round(encoded_plays)
  plays = encoded_plays.map { |play| DECODE[play] }
  PLAY_SCORE[plays[1]] + OUTCOME_SCORE[OUTCOME[plays]]
end

def run
  total = ARGF.map(&:strip)
              .reject(&:empty?)
              .map(&:split)
              .sum { |encoded_plays| score_round(encoded_plays) }

  puts total
end

run if $PROGRAM_NAME == __FILE__
