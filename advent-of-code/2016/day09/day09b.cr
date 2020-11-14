# Advent of Code 2016, day 9, part B

# Reads a number n of length k from text. Returns {pos + k, n}.
def read_number(text, pos)
  acc = 0
  while '0' <= (ch = text[pos]) <= '9'
    acc = acc * 10 + (ch - '0')
    pos += 1
  end
  {pos, acc}
end

# Throws if text does not have a specific character at pos.
def assert_char(text, pos, ch)
  if text[pos] != ch
    raise "Syntax error at char #{pos}: expected '#{ch}', got '#{text[pos]}'"
  end
end

# Reads a subexpression s of length k from text. Returns {pos + k, m} where m
# is the length s would hypothetically expand to.
def decode_initial_length(text, pos)
  return {pos + 1, 1} if text[pos] != '('

  pos, real_length = read_number(text, pos + 1)
  assert_char(text, pos, 'x')
  pos, repcount = read_number(text, pos + 1)
  assert_char(text, pos, ')')

  endpos = pos + 1 + real_length
  expanded_length = decode_length(text, pos + 1, endpos) * repcount
  {endpos, expanded_length}
end

# Computes the length of the hypothetical expansion of text[pos..(endpos - 1)].
def decode_length(text, pos, endpos)
  acc = 0
  while pos < endpos
    pos, delta = decode_initial_length(text, pos)
    acc += delta
  end
  acc
end

text = ARGF.gets_to_end.gsub(/\s+/, "")
puts decode_length(text, 0, text.size)
