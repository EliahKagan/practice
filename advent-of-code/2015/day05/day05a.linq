<Query Kind="Statements" />

// Advent of Code 2015, day 5, part A

var threeVowels = new Regex(@"(?:.*?[aeiou]){3}");
var doubleLetter = new Regex(@"([a-z])\1");
var naughtyPair = new Regex(@"ab|cd|pq|xy");

bool IsNice(string word)
    => threeVowels.IsMatch(word)
    && doubleLetter.IsMatch(word)
    && !naughtyPair.IsMatch(word);

new[] { // Examples from problem statement.
    (word: "ugknbfddgicrmopn",  nice: true),
    (word: "aaa",               nice: true),
    (word: "jchzalrnumimnmhp",  nice: false),
    (word: "haegwjzuvuyypxyu",  nice: false),
    (word: "dvszwmarrgswjxmb",  nice: false)
}.All(row => IsNice(row.word) == row.nice)
 .Dump("Tests OK?");

File.ReadLines("input")
    .Select(line => line.Trim())
    .Where(IsNice)
  //.Dump("nice words (for debugging)")
    .Count()
    .Dump("NICE COUNT");
