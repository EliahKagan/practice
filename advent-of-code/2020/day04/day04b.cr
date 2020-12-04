# Advent of Code 2020, day 4, part B

class String
  def fields
    split.map(&.split(':')).to_h
  end

  def year_in_range?(min, max)
    return false unless self =~ /^\d+$/

    date = to_i
    min <= date <= max
  end

  def allowed_height?
    in_range_with_suffix?(150, 193, "cm") ||
    in_range_with_suffix?(59, 76, "in")
  end

  private def in_range_with_suffix?(min, max, suffix)
    return false unless self =~ /^(\d+)(.*)$/

    _, digits, tail = $~
    min <= digits.to_i <= max && tail == suffix
  end
end

EYE_COLORS = %w[amb blu brn gry grn hzl oth]

valid_count = ARGF.each_line(delimiter: "\n\n").map(&.fields).count do |row|
  row["byr"]?.try(&.year_in_range?(1920, 2002)) &&
  row["iyr"]?.try(&.year_in_range?(2010, 2020)) &&
  row["eyr"]?.try(&.year_in_range?(2020, 2030)) &&
  row["hgt"]?.try(&.allowed_height?) &&
  row["hcl"]?.try { |hcl| hcl =~ /^#[0-9a-f]{6}$/ } &&
  row["ecl"]?.try { |ecl| EYE_COLORS.includes?(ecl) } &&
  row["pid"]?.try { |pid| pid =~ /^\d{9}$/ }
end

puts valid_count
