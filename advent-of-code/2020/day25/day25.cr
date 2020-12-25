# Advent of Code 2020, day 25

DIVISOR = 20_201_227_i64

# Encrypts a message.
def modular_pow(base : Int64, exponent : Int64)
  return 1i64 if exponent.zero?

  power = modular_pow(base, exponent // 2i64)
  power *= power
  power *= base if exponent.odd?
  power % DIVISOR
end

# Brute forces a private key from a public key.
def modular_log(base : Int64, power : Int64)
  acc = 1i64

  (0i64..).each do |exponent|
    return exponent if acc == power
    acc = acc * base % DIVISOR
  end
end

BASE = 7i64

public_keys = ARGF.each_line.map(&.strip).reject(&.empty?).map(&.to_i64).to_a

private_keys = public_keys.map do |pubkey|
  key = modular_log(BASE, pubkey)
  puts "Public key #{pubkey} has private key #{key}."
  key
end

puts
symmetric_key = modular_pow(BASE, private_keys.product)
puts "Handshake established symmetric key #{symmetric_key}."
