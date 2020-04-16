<Query Kind="Statements">
  <Namespace>System.Security.Cryptography</Namespace>
</Query>

// Advent of Code 2015, day 4 (part A).
//
// This way is unnecessarily slow because it involves extra string processing
// and performs numerous memory allocations that could be avoided. But it's
// clear and avoids opportunities for bit-twiddling mistakes. Maybe it'll be
// fast enough.

const string inputPrefix = "abcdef"; // Example string.
const string outputPrefix = "00000";

static IEnumerable<int> UnboundedRange(int start)
{
    checked {
        for (; ; ++start) yield return start;
    }
}

var md5 = MD5.Create();

bool HasDesirableHash(string input)
{
    var hash = md5.ComputeHash(Encoding.UTF8.GetBytes(input));
    var output = string.Concat(hash.Select(octet => octet.ToString("x2")));
    return output.StartsWith(outputPrefix);
}

UnboundedRange(1)
    .Select(inputSuffix => $"{inputPrefix}{inputSuffix}")
    .First(HasDesirableHash)
    .Dump();
