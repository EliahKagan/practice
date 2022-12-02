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
  %i[rock rock] => :draw,
  %i[rock paper] => :win,
  %i[rock scissors] => :lose,
  %i[paper rock] => :lose,
  %i[paper paper] => :draw,
  %i[paper scissors] => :win,
  %i[scissors rock] => :win,
  %i[scissors paper] => :lose,
  %i[scissors scissors] => :draw
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
  puts ARGF.each_line
           .map(&:strip)
           .reject(&:empty?)
           .map(&:split)
           .map { |encoded_plays| score_round(encoded_plays) }
           .sum
end

run if $PROGRAM_NAME == __FILE__
