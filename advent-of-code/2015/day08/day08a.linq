<Query Kind="Statements" />

// Advent of Code 2015, day 8, part A

var entity = new Regex(@"[^""\\]|\\(?:[""\\]|x[0-9a-fA-F]{2})");

File.ReadLines("input")
    .Select(line => line.Trim())
    .Where(line => line.Length > 1 && line[0] == '"' && line[^1] == '"')
    .Select(line => new { line.Length, entity.Matches(line).Count })
    .Sum(lc => lc.Length - lc.Count)
    .Dump();
