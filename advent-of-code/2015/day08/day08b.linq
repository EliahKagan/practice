<Query Kind="Statements" />

// Advent of Code 2015, day 8, part B

const int quotesLength = 2; // Outer quotes contribute 2 to the length.
const int simpleEscapeLength = 1; // Escaping '"' or '\' adds a '\'.

File.ReadLines("input")
    .Select(line => line.Trim())
    .Where(line => line.Length > 1 && line[0] == '"' && line[^1] == '"')
    .Sum(line => quotesLength + line.Sum(ch => ch switch {
                                            '"' => simpleEscapeLength,
                                            '\\' => simpleEscapeLength,
                                            _ => 0
                                        }))
    .Dump();
