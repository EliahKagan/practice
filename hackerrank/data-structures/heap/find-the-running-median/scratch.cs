using System;
using System.Collections.Generic;

internal sealed class Pair<T> {
    internal Pair(T first, T second) => _items = new List<T> { first, second };

    public override string ToString() => $"({_items[0]}, {_items[1]})";

    internal void Swap() => (_items[0], _items[1]) = (_items[1], _items[0]);

    private readonly IList<T> _items;
}

internal static class Program {
    private static void Main()
    {
        var pair = new Pair<int>(10, 20);
        pair.Swap();
        Console.WriteLine(pair);
    }
}
