# Advent of Code 2020, day 13, part A

require "option_parser"

verbose = false

OptionParser.parse do |parser|
  parser.on "-v", "--verbose", "Show some debugging information" do
    verbose = true
  end
  parser.on "-h", "--help", "Show options help and exit" do
    puts parser
    exit
  end
end

departure = ARGF.gets.as(String).to_i

answer = ARGF.gets.as(String)
  .strip
  .split(',')
  .reject("x")
  .map(&.to_i)
  .map { |period| {-departure % period, period} }
  .min
  .tap { |pair| puts pair if verbose }
  .product

puts answer
