// HackerRank - Median Updates
// https://www.hackerrank.com/challenges/median
// In C# 6.0, because that's what HackerRank supports.
// Using trees of element frequencies. This is a two-tree solution, analogous
// to the two-heap solution to the simpler variant that has no removals.
//
// This version has some optimizations trading elegance and clarity for speed.

using System;
using System.Collections.Generic;
using System.Linq;

internal static class ReverseComparer {
    internal static IComparer<T> Reverse<T>(this IComparer<T> comparer)
        => new ReverseComparer<T>(comparer);
}

internal sealed class ReverseComparer<T> : IComparer<T> {
    internal ReverseComparer(IComparer<T> comparer) => _comparer = comparer;

    public int Compare(T lhs, T rhs) => _comparer.Compare(rhs, lhs);

    private readonly IComparer<T> _comparer;
}

internal static class SortedBag {
    internal static SortedBag<T> CreateMinTree<T>()
        => new SortedBag<T>(Comparer<T>.Default);

    internal static SortedBag<T> CreateMaxTree<T>()
        => new SortedBag<T>(Comparer<T>.Default.Reverse());
}

internal sealed class SortedBag<T> {

    internal SortedBag(IComparer<T> comparer)
        => _freqs = new SortedDictionary<T, int>(comparer);

    internal int Count { get; private set; } = 0;

    internal void Push(T value)
    {
        if (_freqs.TryGetValue(value, out var freq))
            _freqs[value] = freq + 1;
        else
            _freqs.Add(value, 1);

        ++Count;
    }

    internal bool Remove(T value)
    {
        if (!_freqs.TryGetValue(value, out var freq)) return false;

        if (freq == 1)
            _freqs.Remove(value);
        else
            _freqs[value] = freq - 1;

        --Count;
        return true;
    }

    internal T Pop()
    {
        var entry = _freqs.First();
        var value = entry.Key;
        var freq = entry.Value;

        if (freq == 1)
            _freqs.Remove(value);
        else
            _freqs[value] = freq - 1;

        --Count;
        return value;
    }

    internal T Peek() => _freqs.First().Key;

    private readonly SortedDictionary<T, int> _freqs;
}

internal sealed class MedianBag {
    internal int Count => _low.Count + _high.Count;

    internal void Add(int value)
    {
        if (_low.Count != 0 && value < _low.Peek())
            _low.Push(value);
        else
            _high.Push(value);

        Rebalance();
    }

    internal bool Remove(int value)
    {
        if (_low.Remove(value) || _high.Remove(value)) {
            Rebalance();
            return true;
        }

        return false;
    }

    internal double Median
    {
        get {
            if (Count == 0)
                throw new InvalidOperationException("empty bag has no median");

            switch (BalanceFactor) {
            case -1:
                return _low.Peek();

            case +1:
                return _high.Peek();

            case 0:
                return ((double)_low.Peek() + (double)_high.Peek()) / 2.0;

            default:
                throw new NotSupportedException(
                        "Bug: balancing invariant violated");
            }
        }
    }

    private void Rebalance()
    {
        switch (BalanceFactor) {
        case -2:
            _high.Push(_low.Pop());
            break;

        case +2:
            _low.Push(_high.Pop());
            break;

        default:
            break; // Can't be made more balanced.
        }
    }

    private int BalanceFactor => _high.Count - _low.Count;

    private readonly SortedBag<int> _low = SortedBag.CreateMaxTree<int>();

    private readonly SortedBag<int> _high = SortedBag.CreateMinTree<int>();
}

internal static class Solution {
    private static int ReadValue() => int.Parse(Console.ReadLine());

    private static string[] ReadTokens()
        => Console.ReadLine()
                  .Split((char[])null, StringSplitOptions.RemoveEmptyEntries);

    private static void Main()
    {
        var bag = new MedianBag();

        for (var count = ReadValue(); count > 0; --count) {
            var tokens = ReadTokens();
            var opcode = tokens[0][0];
            var argument = int.Parse(tokens[1]);

            switch (opcode) {
            case 'a':
                bag.Add(argument);
                break;

            case 'r':
                if (!bag.Remove(argument) || bag.Count == 0) {
                    Console.WriteLine("Wrong!");
                    continue;
                }
                break;

            default:
                break; // Ignore unrecognized opcodes.
            }

            Console.WriteLine(bag.Median);
        }
    }
}
