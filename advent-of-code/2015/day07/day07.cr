UNARY_OPERATIONS = {
  "NOT" => ->(arg: UInt16) { ~arg }
}

BINARY_OPERATIONS = {
  "AND" => ->(arg1 : UInt16, arg2 : UInt16) { arg1 & arg2 },
  "OR" => ->(arg1 : UInt16, arg2 : UInt16) { arg1 | arg2 },
  "LSHIFT" => ->(arg1 : UInt16, arg2 : UInt16) { arg1 << arg2 },
  "RSHIFT" => ->(arg1 : UInt16, arg2 : UInt16) { arg1 >> arg2 }
}
