<Query Kind="Statements">
  <Namespace>System.Security.Cryptography</Namespace>
</Query>

// Advent of Code 2015, day 4 (part A).
//
// This way is unnecessarily slow because it involves extra string processing
// and performs numerous memory allocations that could be avoided. But it's
// clear and avoids opportunities for bit-twiddling mistakes.

const string inPrefix = "yzbqklnj"; // Puzzle input.
const string outPrefix = "00000";

static IEnumerable<int> UnboundedRange(int start)
{
    checked {
        for (; ; ++start) yield return start;
    }
}

var md5 = MD5.Create();

bool HasMD5Prefix(string message, string digestPrefix)
{
    var hash = md5.ComputeHash(Encoding.UTF8.GetBytes(message));
    var output = string.Concat(hash.Select(octet => octet.ToString("x2")));
    return output.StartsWith(digestPrefix);
}

UnboundedRange(1)
    .First(inSuffix => HasMD5Prefix($"{inPrefix}{inSuffix}", outPrefix))
    .Dump();
