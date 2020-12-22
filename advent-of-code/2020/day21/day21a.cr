# Advent of Code 2020, day 21, part A

# ingredient => how many times it has appeared
ingredient_freqs = Hash(String, Int32).new(0)

# allergin => ingredients that may have it
candidates = {} of String => Set(String)

ARGF.each_line.map(&.strip).reject(&.empty?).each do |line|
  unless line =~ /^((?:\w+\s+)+)\(contains\s+(\w+(?:,\s+\w+)*)\)$/
    raise "malformed line"
  end
  _, ingredients_text, allergins_text = $~
  ingredients = ingredients_text.split
  allergins = allergins_text.split(/,\s+/)

  ingredients.each { |ingredient| ingredient_freqs[ingredient] += 1 }

  ingredients_set = ingredients.to_set

  allergins.each do |allergin|
    if candidates.has_key?(allergin)
      candidates[allergin] &= ingredients_set
    else
      candidates[allergin] = ingredients_set
    end
  end
end

# ingredients that may contain an allergin
allergenic_ingredients =
  candidates.each_value.reduce { |acc, elem| acc | elem }

total_nonallergenic_ingredient_frequency = ingredient_freqs
  .reject { |ingredient, _freq| allergenic_ingredients.includes?(ingredient) }
  .each_value
  .sum

puts total_nonallergenic_ingredient_frequency
