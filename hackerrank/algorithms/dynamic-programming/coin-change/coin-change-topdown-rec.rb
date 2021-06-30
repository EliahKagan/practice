#!/usr/bin/env ruby
# frozen_string_literal: true

# HackerRank: The Coin Change Problem
# https://www.hackerrank.com/challenges/coin-change
# By recursive top-down DP (memoization).

$VERBOSE = 1

def count_ways(coins, total)
  dp = {}

  solve = lambda do |index, subtot|
    return 1 if subtot.zero?

    return 0 if index == coins.size

    dp[[index, subtot]] ||= (0..subtot).step(coins[index]).sum do |delta|
      solve.call(index + 1, subtot - delta)
    end
  end

  solve.call(0, total)
end

def read_record(size)
  record = gets.split.map(&:to_i)
  raise 'wrong record size' if record.size != size
  record
end

def run
  total, coin_count = read_record(2)
  coins = read_record(coin_count)
  puts count_ways(coins, total)
end

run if $PROGRAM_NAME == __FILE__
