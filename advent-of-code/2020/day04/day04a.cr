# Advent of Code 2020, day 4, part A

def parse_fields(stanza)
  stanza.split.map(&.split(':').first).to_set
end

EXPECTED_FIELDS = %w[byr iyr eyr hgt hcl ecl pid].to_set
OPTIONAL_FIELDS = %w[cid].to_set
RECOGNIZED_FIELDS = EXPECTED_FIELDS | OPTIONAL_FIELDS

groups = ARGF.each_line(delimiter: "\n\n")
             .map { |stanza| parse_fields(stanza) }

valid_count = groups.count do |fields|
  unrecognized = fields - RECOGNIZED_FIELDS
  unless unrecognized.empty?
    list = unrecognized.join(", ")
    STDERR.puts "#{PROGRAM_NAME}: warning: unrecognized fields: #{list}"
  end

  EXPECTED_FIELDS.subset?(fields)
end

puts valid_count
