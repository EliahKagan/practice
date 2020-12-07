# Advent of Code 2020, day 7, part B - alternate approach, using a thunk table

def inner_colors_with_count(inner_info)
  inner_fields = inner_info.split(", ")
	raise "Malformed rule: no fields" if inner_fields.empty?

  inner_fields.map do |field|
    unless field =~ /^(\d+) \b(.+)\b bags?$/
      raise "Malformed rule: wrong field format"
    end

    _, digits, color = $~
    count = digits.to_i64
    raise "Bad rule: zero-count containment unsupported" if count.zero?

    {color, count}
  end
end

thunks = {} of String => (-> Int64)

ARGF.each_line.map(&.strip).reject(&.empty?).each do |line|
  unless line =~ /^\b(.+)\b bags contain \b(.+)\b\.$/
    raise "Malformed rule: unrecognized format"
  end
  _, outer_color, inner_info = $~

  if inner_info == "no other bags"
    thunks[outer_color] = ->{ 1i64 }
		next
  end

  inner_color_counts = inner_colors_with_count(inner_info)

  thunks[outer_color] = ->do
    thunks[outer_color] = ->do
      raise %Q{Infinite cost due to cycle at "#{outer_color}".}
    end

    cost = inner_color_counts.sum(1i64) do |color, count|
      thunks[color].call * count
    end

    thunks[outer_color] = ->{ cost }
    cost
  end
end

puts thunks["shiny gold"].call - 1i64
