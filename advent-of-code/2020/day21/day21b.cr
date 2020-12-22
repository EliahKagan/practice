# Advent of Code, day 21, part B - investigation

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

choice_counts = candidates
  .reject { |_allergin, ingredients| ingredients.empty? }
  .each_value
  .map(&.size)
  .to_a

pp choice_counts
