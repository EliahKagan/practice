# Advent of Code 2018, day 4, part A

HOURS_PER_DAY = 24
MINUTES_PER_HOUR = 60

# guard id => minute => asleep count
slumbers = Hash(Int32, Array(Int32)).new do |hash, key|
  hash[key] = [0] * MINUTES_PER_HOUR
end

guard = nil
start = nil

ARGF.each_line.map(&.strip).reject(&.empty?).to_a.sort!.each do |line|
  unless line =~ /^\[\d{4}(?:-\d\d){2}\s+(\d\d):(\d\d)\]\s+\b(.+)$/
    raise "malformed log entry: #{line}"
  end
  
  _, hh, mm, event = $~
  hour = hh.to_i
  minute = mm.to_i
  raise "hour #{hour} out of range" unless 0 <= hour < HOURS_PER_DAY
  raise "minute #{minute} out of range" unless 0 <= minute < MINUTES_PER_HOUR

  case event
  when /^Guard #(\d+) begins shift$/
    _, g = $~
    raise "new guard while old guard is still asleep" if start
    guard = g.to_i
  when "falls asleep"
    raise "very talented guard falls asleep without even existing" unless guard
    raise "reentrant sleeping unsupported, lay off the eggnog" if start
    raise "guard fell asleep outside the midnight hour" unless hour.zero?
    start = minute
  when "wakes up"
    raise "very talented guard wakes up without even existing" unless guard
    raise "unsleeping guard woke up, that doesn't sound right" unless start
    raise "guard wakes up outside the midnight hour" unless hour.zero?
    raise "Bug: guard slept for a negative time" if minute < start
    row = slumbers[guard]
    start.upto(minute - 1).each { |time| row[time] += 1 }
    start = nil
  else
    raise "indecipherable event: #{event}"
  end
end

raise "guard #{guard} is still asleep!" if start

guard, row = slumbers.max_by { |_, row| row.sum }
_, minute = row.each_with_index.max
puts guard * minute
