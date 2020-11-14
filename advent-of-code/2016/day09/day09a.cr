# Advent of Code 2016, day 9, part A

class Scanner
  class Error < Exception
  end

  def initialize(@text : String)
    @pos = 0
  end

  def end?
    @pos >= @text.size
  end

  def scan
    raise Error.new("can't scan past the end") if end?

    ch = @text[@pos]
    @pos += 1
    return 1 if ch != '('

    length = read_number
    read_specific_char('x')
    repcount = read_number
    read_specific_char(')')

    @pos += length
    raise Error.new("command moved position past the end") if @pos > @text.size
    length * repcount
  end

  private def read_number
    acc = 0
    while '0' <= (ch = @text[@pos]) <= '9'
      acc = acc * 10 + (ch - '0')
      @pos += 1
    end
    acc
  end

  private def read_specific_char(need_ch)
    ch = @text[@pos]
    raise Error.new("expected '#{need_ch}', got '#{ch}'") if ch != need_ch
    @pos += 1
    nil
  end
end

scanner = Scanner.new(ARGF.gets_to_end.gsub(/\s+/, ""))
acc = 0
until scanner.end?
  acc += scanner.scan
end
puts acc
