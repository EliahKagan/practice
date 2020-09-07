// HackerRank - Median Updates
// https://www.hackerrank.com/challenges/median
// In C# 6.0, because that's what HackerRank supports. The problem is intended
// to be solved with self-balancing trees, but this solution uses binary heaps
// equipped with an O(log(n)) remove operation.

using System;
using System.Collections.Generic;

internal static class Extensions {
    internal static T PeekElement<T>(this ISet<T> set)
    {
        using (var en = set.GetEnumerator()) {
            if (!en.MoveNext()) {
                throw new InvalidOperationException(
                        "cant peek element from empty set");
            }

            return en.Current;
        }
    }

    internal static void EnsureAdd<T>(this ISet<T> set, T element)
    {
        if (!set.Add(element)) {
            throw new InvalidOperationException(
                    "element to add to set was already present");
        }
    }

    internal static void EnsureRemove<T>(this ISet<T> set, T element)
    {
        if (!set.Remove(element)) {
            throw new InvalidOperationException(
                    "element to remove from set was not found");
        }
    }

    internal static void
    EnsureRemove<TKey, TValue>(this IDictionary<TKey, TValue> map, TKey key)
    {
        if (!map.Remove(key)) {
            throw new InvalidOperationException(
                    "key to remove from dictionary was not found");
        }
    }

    internal static
    TValue GetOrCreate<TKey, TValue>(this IDictionary<TKey, TValue> map,
                                     TKey key) where TValue : new()
    {
        if (!map.TryGetValue(key, out var value)) {
            value = new TValue();
            map.Add(key, value);
        }

        return value;
    }
}

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
        var index = SiftUp(value);
        _map.GetOrCreate(value).Add(index);
        _heap[index] = value;
    }

    internal T Pop()
    {
        var value = Peek();

        if (Count == 1) {
            Clear();
        } else {
            var indices = _map[value];

            if (indices.Count == 1)
                _map.EnsureRemove(value);
            else
                indices.EnsureRemove(0);

            CutRoot();
        }

        return value;
    }

    internal T Peek()
    {
        if (Count == 0) {
            throw new InvalidOperationException(
                    "empty heap has no first element");
        }

        return _heap[0];
    }

    internal bool Remove(T value)
    {
        if (!_map.TryGetValue(value, out var indices)) return false;

        if (Count == 1) {
            Clear();
        } else {
            var child = indices.PeekElement();

            if (indices.Count == 1) {
                _map.EnsureRemove(value);
            } else {
                child = HighestEqualAncestor(child);
                indices.EnsureRemove(child);
            }

            YankUp(child);
            CutRoot();
        }

        return true;
    }

    private const int NoChild = -1;

    private static int ParentOf(int child) => (child - 1) / 2;

    private static int LeftChildOf(int parent) => parent * 2 + 1;

    private static int RightChildOf(int parent) => parent * 2 + 2;

    private BinaryHeap(Comparison<T> comp) => _comp = comp;

    private void CutRoot()
    {
        var last = Count - 1;
        var value = _heap[last];
        _heap.RemoveAt(last);

        var indices = _map[value];
        indices.EnsureRemove(last);

        var index = SiftDown(value);
        indices.EnsureAdd(index);
        _heap[index] = value;
    }

    private int HighestEqualAncestor(int child)
    {
        var value = _heap[child];

        while (child != 0) {
            var parent = ParentOf(child);
            if (!_heap[parent].Equals(value)) break;
            child = parent;
        }

        return child;
    }

    private void YankUp(int child)
    {
        while (child != 0) {
            var parent = ParentOf(child);
            var parentValue = _heap[parent];

            var indices = _map[parentValue];
            indices.EnsureRemove(parent);
            indices.EnsureAdd(child);
            _heap[child] = parentValue;

            child = parent;
        }
    }

    private int SiftUp(T childValue)
    {
        var child = Count - 1;

        while (child != 0) {
            var parent = ParentOf(child);
            var parentValue = _heap[parent];
            if (_comp(parentValue, childValue) <= 0) break;

            var indices = _map[parentValue];
            indices.EnsureRemove(parent);
            indices.EnsureAdd(child);
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
            var childValue = _heap[child];
            if (_comp(parentValue, childValue) <= 0) break;

            var indices = _map[childValue];
            indices.EnsureRemove(child);
            indices.EnsureAdd(parent);
            _heap[parent] = childValue;

            parent = child;
        }

        return parent;
    }

    private int PickChild(int parent)
    {
        var left = LeftChildOf(parent);
        if (left >= Count) return NoChild;

        var right = RightChildOf(parent);
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
            if (Count == 0)
                throw new InvalidOperationException("empty bag has no median");

            switch (BalanceFactor) {
            case -1:
                return _low.Peek();

            case +1:
                return _high.Peek();

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
            var opcode = tokens[0];
            var argument = int.Parse(tokens[1]);

            switch (opcode) {
            case "a":
                bag.Add(argument);
                Console.WriteLine(bag.Median);
                break;

            case "r":
                if (bag.Remove(argument) && bag.Count != 0)
                    Console.WriteLine(bag.Median);
                else
                    Console.WriteLine("Wrong!");

                break;

            default:
                throw new InvalidOperationException(
                        $"unrecognized opcode \"{opcode}\"");
            }
        }
    }
}
