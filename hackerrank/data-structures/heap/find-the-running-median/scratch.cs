using System;
using System.Collections.Generic;

internal static class Program {
    private static void Main()
    {
        var a = new List<string> { "foo", "bar" };
        var i = 0;
        var j = 1;
        Console.WriteLine(string.Join(" ", a));
        (a[i], a[j]) = (a[j], a[i]);
        Console.WriteLine(string.Join(" ", a));
    }
}
