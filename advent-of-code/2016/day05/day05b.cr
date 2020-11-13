# Advent of Code 2016, day 5, part B

require "digest/md5"

DIGEST_PREFIX = "00000"
DIGEST_POS_INDEX = DIGEST_PREFIX.size
DIGEST_CHAR_INDEX = DIGEST_POS_INDEX + 1

struct PasswordCracker
  def initialize(@prefix : String, @size : Int32)
    @password = Array(Char?).new(@size, nil)
    @unknown = @size
    @index = 0
  end

  def done?
    @unknown.zero?
  end

  def results
    @password.dup
  end

  def compute_char
    raise ArgumentError.new("all characters computed") if done?

    loop do
      digest = Digest::MD5.hexdigest("#{@prefix}#{@index}")
      @index += 1
      next unless digest.starts_with?(DIGEST_PREFIX)
      
      pos = digest[DIGEST_POS_INDEX] - '0'
      next unless 0 <= pos < @size && @password[pos].nil?

      @password[pos] = digest[DIGEST_CHAR_INDEX]
      @unknown -= 1
      break
    end
  end
end

cracker = PasswordCracker.new(ARGV[0], 8)
until cracker.done?
  cracker.compute_char
end
password = cracker.results
raise "Bug: complete password contains nil" if password.any?(&.nil?)
puts password.join
