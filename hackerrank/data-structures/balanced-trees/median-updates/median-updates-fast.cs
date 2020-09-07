// HackerRank - Median Updates
// https://www.hackerrank.com/challenges/median
// In C# 6.0, because that's what HackerRank supports. The problem is intended
// to be solved with self-balancing trees, but this solution uses binary heaps
// equipped with an O(log(n)) remove operation.
//
// This version has less error checking (and is arguably less elegant) than
// median-updates.cs, to eke out some more speed.

using System;
using System.Collections.Generic;
using System.Linq;

/// <summary>A priority queue with an O(log(n)) remove operation.</summary>
/// <remarks>
/// Implemented as a binary heap augmented with a table mapping each key to all
/// of its occurrences in the heap.
/// </remarks>
internal sealed class BinaryHeap<T> where T : IEquatable<T>, IComparable<T> {
    internal static BinaryHeap<T> CreateMinHeap()
        => new BinaryHeap<T>((lhs, rhs) => lhs.CompareTo(rhs));

    internal static BinaryHeap<T> CreateMaxHeap()
        => new BinaryHeap<T>((lhs, rhs) => rhs.CompareTo(lhs));

    internal int Count => _heap.Count;

    internal void Clear()
    {
        _heap.Clear();
        _map.Clear();
    }

    internal void Push(T value)
    {
        _heap.Add(default(T));
        var child = SiftUp(value);

        if (!_map.TryGetValue(value, out var indices)) {
            indices = new HashSet<int>();
            _map.Add(value, indices);
        }

        indices.Add(child);
        _heap[child] = value;
    }

    internal T Pop()
    {
        var value = Peek();

        if (Count == 1) {
            Clear();
        } else {
            var indices = _map[value];

            if (indices.Count == 1)
                _map.Remove(value);
            else
                indices.Remove(0);

            CutRoot();
        }

        return value;
    }

    internal T Peek() => _heap[0];

    internal bool Remove(T value)
    {
        if (!_map.TryGetValue(value, out var indices)) return false;

        if (Count == 1) {
            Clear();
        } else {
            // Get any index to this value in the heap.
            var child = indices.First();

            if (indices.Count == 1) {
                _map.Remove(value);
            } else {
                child = HighestEqualAncestor(child);
                indices.Remove(child);
            }

            YankUp(child);
            CutRoot();
        }

        return true;
    }

    private const int NoChild = -1;

    private BinaryHeap(Comparison<T> comp) => _comp = comp;

    private void CutRoot()
    {
        var last = Count - 1;
        var value = _heap[last];
        _heap.RemoveAt(last);

        var indices = _map[value];
        indices.Remove(last);

        var index = SiftDown(value);
        indices.Add(index);
        _heap[index] = value;
    }

    private int HighestEqualAncestor(int child)
    {
        var value = _heap[child];

        while (child != 0) {
            var parent = (child - 1) / 2;
            if (!_heap[parent].Equals(value)) break;
            child = parent;
        }

        return child;
    }

    private void YankUp(int child)
    {
        while (child != 0) {
            var parent = (child - 1) / 2;
            var parentValue = _heap[parent];

            var indices = _map[parentValue];
            indices.Remove(parent);
            indices.Add(child);
            _heap[child] = parentValue;

            child = parent;
        }
    }

    private int SiftUp(T childValue)
    {
        var child = Count - 1;

        while (child != 0) {
            var parent = (child - 1) / 2;
            var parentValue = _heap[parent];
            if (_comp(parentValue, childValue) <= 0) break;

            var indices = _map[parentValue];
            indices.Remove(parent);
            indices.Add(child);
            _heap[child] = parentValue;

            child = parent;
        }

        return child;
    }

    private int SiftDown(T parentValue)
    {
        var parent = 0;

        for (; ; ) {
            var child = PickChild(parent);
            if (child == NoChild) break;
            var childValue = _heap[child];
            if (_comp(parentValue, childValue) <= 0) break;

            var indices = _map[childValue];
            indices.Remove(child);
            indices.Add(parent);
            _heap[parent] = childValue;

            parent = child;
        }

        return parent;
    }

    private int PickChild(int parent)
    {
        var left = parent * 2 + 1;
        if (left >= Count) return NoChild;

        var right = left + 1;
        return right >= Count || _comp(_heap[left], _heap[right]) <= 0
                ? left
                : right;
    }

    private readonly Dictionary<T, HashSet<int>> _map =
        new Dictionary<T, HashSet<int>>();

    private readonly List<T> _heap = new List<T>();

    private readonly Comparison<T> _comp;
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

    private readonly BinaryHeap<int> _low = BinaryHeap<int>.CreateMaxHeap();

    private readonly BinaryHeap<int> _high = BinaryHeap<int>.CreateMinHeap();
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
