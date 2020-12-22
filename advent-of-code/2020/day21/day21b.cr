# Advent of Code 2020, day 21, part B

require "option_parser"

verbose = false

OptionParser.parse do |parser|
  parser.on "-v", "--verbose",
            "pretty-print full candidate information after all eliminations" do
    verbose = true
  end
  parser.on "-h", "--help", "display options help" do
    puts parser
    exit
  end
end

# allergin => ingredients that may have it
candidates = {} of String => Set(String)

ARGF.each_line.map(&.strip).reject(&.empty?).each do |line|
  unless line =~ /^((?:\w+\s+)+)\(contains\s+(\w+(?:,\s+\w+)*)\)$/
    raise "malformed line"
  end
  _, ingredients_text, allergins_text = $~
  ingredients = ingredients_text.split.to_set
  allergins = allergins_text.split(/,\s+/)

  allergins.each do |allergin|
    if candidates.has_key?(allergin)
      candidates[allergin] &= ingredients
    else
      candidates[allergin] = ingredients
    end
  end
end

candidates.reject! { |_allergin, ingredients| ingredients.empty? }
ingredient_rows = candidates.values
prev_solved_ingredients = [] of String

loop do # This is slow (quadratic), but the problem size is very small.
  solved_ingredients = ingredient_rows.each.select(&.one?).map(&.first).to_a
  break if solved_ingredients == prev_solved_ingredients
  ingredient_rows.each.reject(&.one?).each(&.subtract(solved_ingredients))
  prev_solved_ingredients = solved_ingredients
end

if verbose
  pp candidates
  puts
end

unless ingredient_rows.all?(&.one?)
  puts "Couldn't solve."
  exit 1
end

dangerous_ingredients = candidates.to_a
  .sort_by! { |allergin, _ingredients| allergin }
  .each
  .map { |(_allergin, ingredients)| ingredients.first }
  .join(',')

puts dangerous_ingredients
