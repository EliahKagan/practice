def unary(&block : UInt16 -> UInt16)
  block
end

def binary(&block : (UInt16, UInt16) -> UInt16)
  block
end

UNARIES = {
  "NOT" => unary { |arg| ~arg }
}

BINARIES = {
  "AND" => binary { |arg1, arg2| arg1 & arg2 },
  "OR" => binary { |arg1, arg2| arg1 | arg2 },
  "LSHIFT" => binary { |arg1, arg2| arg1 << arg2 },
  "RSHIFT" => binary { |arg1, arg2| arg1 >> arg2 }
}
