<Query Kind="Statements" />

var input = File.ReadAllText("input");
var inc = input.Count(ch => ch == '(');
var dec = input.Count(ch => ch == ')');
(inc - dec).Dump();
