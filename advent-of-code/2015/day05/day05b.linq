<Query Kind="Statements" />

// Advent of Code 2015, day 5, part A

var pairTwice = new Regex(@"([a-z]{2}).*?\1");
var sandwich = new Regex(@"([a-z]).\1");

bool IsNice(string word)
    => pairTwice.IsMatch(word) && sandwich.IsMatch(word);

new[] { // Examples from problem statement.
    (word: "qjhvhtzxzqqjkmpb",  nice: true),
    (word: "xxyxx",             nice: true),
    (word: "uurcxstgmygtbstg",  nice: false),
    (word: "ieodomkazucvgmuy",  nice: false)
}.All(row => IsNice(row.word) == row.nice)
 .Dump("Tests OK?");

File.ReadLines("input")
    .Select(line => line.Trim())
    .Where(IsNice)
  //.Dump("nice words (for debugging)")
    .Count()
    .Dump("NICE COUNT");
