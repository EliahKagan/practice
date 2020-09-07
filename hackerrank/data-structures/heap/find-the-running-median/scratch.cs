using System;
using System.Collections.Generic;

internal sealed class PriorityQueue<T> {
    internal void Swap(int i, int j)
        => (_heap[0], _heap[1]) = (_heap[1], _heap[0]);

    private readonly IList<T> _heap = new List<T>();
}

internal static class Program {
    private static void Main()
    {
        var pq = new PriorityQueue<int>();
    }
}
