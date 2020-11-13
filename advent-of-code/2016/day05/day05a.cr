# Advent of Code 2016, day 5, part A

require "digest/md5"

HASH_PREFIX = "00000"
HASH_INDEX = HASH_PREFIX.size

struct PasswordCracker
  @index = 0

  def initialize(@prefix : String)
  end

  def next_char
    loop do
      hash = Digest::MD5.hexdigest("#{@prefix}#{@index}")
      @index += 1
      return hash[HASH_INDEX] if hash.starts_with?(HASH_PREFIX)
    end
  end
end

pw = PasswordCracker.new(ARGV[0])
puts (1..8).map { pw.next_char }.join
