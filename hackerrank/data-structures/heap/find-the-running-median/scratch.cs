using System;
using System.Collections.Generic;

internal sealed class Pair {
    public override string ToString() => $"({_items[0]}, {_items[1]})";

    internal void Swap(int i, int j)
        => (_items[i], _items[j]) = (_items[j], _items[i]);

    private readonly IList<string> _items = new List<string>() { "foo", "bar" };
}

internal static class Program {
    private static void Main()
    {
        var pair = new Pair();
        Console.WriteLine(pair);
        pair.Swap(0, 1);
        Console.WriteLine(pair);
    }
}
