// HackerRank - Median Updates
// https://www.hackerrank.com/challenges/median
// In C# 6.0, because that's what HackerRank supports.
// Using trees of element frequencies. This is a two-tree solution, analogous
// to the two-heap solution to the simpler variant that has no removals.
//
// This version is rewritten to trade elegance and clarity for speed.

using System;
using System.Collections.Generic;
using System.Linq;

/// <summary>
/// An ascending BST-based multiset stored as value-frequency mappings.
/// </summary>
internal sealed class MinTree {
    internal int Count { get; private set; } = 0;

    internal void Push(long value)
    {
        if (_freqs.TryGetValue(value, out var freq))
            _freqs[value] = freq + 1;
        else
            _freqs.Add(value, 1);

        ++Count;
    }

    internal bool Remove(long value)
    {
        if (!_freqs.TryGetValue(value, out var freq)) return false;

        if (freq == 1)
            _freqs.Remove(value);
        else
            _freqs[value] = freq - 1;

        --Count;
        return true;
    }

    internal long Pop()
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

    internal long Peek() => _freqs.First().Key;

    private readonly SortedDictionary<long, int> _freqs =
        new SortedDictionary<long, int>();
}

/// <summary>
/// An descending BST-based multiset stored as value-frequency mappings.
/// </summary>
internal sealed class MaxTree {
    internal int Count => _tree.Count;

    internal void Push(long value) => _tree.Push(-value);

    internal bool Remove(long value) => _tree.Remove(-value);

    internal long Pop() => -_tree.Pop();

    internal long Peek() => -_tree.Peek();

    private readonly MinTree _tree = new MinTree();
}

internal sealed class MedianBag {
    internal int Count => _low.Count + _high.Count;

    internal void Add(long value)
    {
        if (_low.Count != 0 && value < _low.Peek())
            _low.Push(value);
        else
            _high.Push(value);

        Rebalance();
    }

    internal bool Remove(long value)
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
            switch (BalanceFactor) {
            case -1:
                return _low.Peek();

            case +1:
                return _high.Peek();

            case 0:
                return (_low.Peek() + _high.Peek()) / 2.0;

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

    private readonly MaxTree _low = new MaxTree();

    private readonly MinTree _high = new MinTree();
}

internal static class Solution {
    private static int ReadCount() => int.Parse(Console.ReadLine());

    private static string[] ReadTokens()
        => Console.ReadLine()
                  .Split((char[])null, StringSplitOptions.RemoveEmptyEntries);

    private static void Main()
    {
        var bag = new MedianBag();

        for (var count = ReadCount(); count > 0; --count) {
            var tokens = ReadTokens();
            var opcode = tokens[0][0];
            var argument = long.Parse(tokens[1]);

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
