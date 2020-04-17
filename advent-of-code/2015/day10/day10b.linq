<Query Kind="Statements" />

// Advent of code 2015, day 10, part B

var contiguous = new Regex(@"(.)\1*");

IEnumerable<string> LookAndSay(string number)
{
    for (; ; ) {
        number = string.Concat(from match in contiguous.Matches(number)
                               let digit = match.Groups[1].Value
                               let count = match.Length
                               select $"{count}{digit}");
        
        yield return number;
    }
}

LookAndSay("1113222113")
    .Take(50) // 50 instead of 40
  //.Dump("debug")
    .Last()
    .Length
    .Dump("answer");
