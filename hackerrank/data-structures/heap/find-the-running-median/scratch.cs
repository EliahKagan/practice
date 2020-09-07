using System;
using System.Collections.Generic;

internal sealed class Pair<T> {
    internal Pair(T first, T second) => Items = new List<T> { first, second };

    internal IList<T> Items { get; }

    internal void Swap() => (Items[0], Items[1]) = (Items[1], Items[0]);
}

internal static class Program {
    private static void Main()
    {
        var pair = new Pair<int>(10, 20);
        pair.Swap();
        Console.WriteLine($"({pair.Items[0]}, {pair.Items[1]})");
    }
}
