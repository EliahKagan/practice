using System;
using System.Collections.Generic;

internal sealed class PriorityQueue<T> {
    internal void Swap(int i, int j)
        => (_heap[i], _heap[j]) = (_heap[j], _heap[i]);

    private readonly IList<T> _heap = new List<T>();
}

internal static class Program {
    private static void Main()
    {
        var pq = new PriorityQueue<int>();
    }
}
