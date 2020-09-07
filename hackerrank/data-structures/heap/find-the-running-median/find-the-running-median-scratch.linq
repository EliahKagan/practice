<Query Kind="Program" />

internal sealed class ReverseComparer<T> : IComparer<T> {
    internal ReverseComparer(IComparer<T> comparer) => _comparer = comparer;

    public int Compare(T lhs, T rhs) => _comparer.Compare(rhs, lhs);

    private readonly IComparer<T> _comparer;
}

internal sealed class PriorityQueue<T> {
    internal static PriorityQueue<T> CreateMinHeap()
        => new PriorityQueue<T>(Comparer<T>.Default);

    internal static PriorityQueue<T> CreateMaxHeap()
        => new PriorityQueue<T>(new ReverseComparer<T>(Comparer<T>.Default));

    internal PriorityQueue(IComparer<T> comparer) => _comparer = comparer;

    internal int Count => _heap.Count;

    internal void Push(T value)
    {
        _heap.Add(value);
        SiftUp(Count - 1);
    }

    internal T Pop()
    {
        var value = Peek();
        _heap[0] = _heap[Count - 1];
        _heap.RemoveAt(Count - 1);
        SiftDown(0);
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

    private const int NoChild = -1;

    private void SiftUp(int child)
    {
        while (child != 0) {
            var parent = (child - 1) / 2;
            if (OrderOk(parent, child)) break;

            Swap(parent, child);
            child = parent;
        }
    }

    private void SiftDown(int parent)
    {
        for (; ; ) {
            var child = PickChild(parent);
            if (child == NoChild || OrderOk(parent, child)) break;

            Swap(parent, child);
            parent = child;
        }
    }

    private int PickChild(int parent)
    {
        var left = parent * 2 + 1;
        if (left >= Count) return NoChild;

        var right = left + 1;
        return right == Count || OrderOk(left, right) ? left : right;
    }

    private bool OrderOk(int parent, int child)
        => _comparer.Compare(_heap[parent], _heap[child]) <= 0;

    private void Swap(int i, int j)
        => (_heap[i], _heap[j]) = (_heap[j], _heap[i]);

    private object ToDump() => _heap;

    private readonly IList<T> _heap = new List<T>();

    private readonly IComparer<T> _comparer;
}

internal sealed class MedianBag {
    internal void Add(int value)
    {
        if (_low.Count != 0 && value < _low.Peek())
            _low.Push(value);
        else
            _high.Push(value);

        Rebalance();
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
        
        _low.Dump(nameof(_low));
        _high.Dump(nameof(_high));
    }

    private int BalanceFactor => _high.Count - _low.Count;

    private readonly PriorityQueue<int> _low =
        PriorityQueue<int>.CreateMaxHeap();

    private readonly PriorityQueue<int> _high =
        PriorityQueue<int>.CreateMinHeap();
}

internal static class Solution {
    private static int ReadValue() => int.Parse(Console.ReadLine());

    private static void Main()
    {
        var bag = new MedianBag();
        
        foreach (var value in Enumerable.Range(1, 10)) {
            bag.Add(value);
            $"{bag.Median:F1}".Dump($"median after {value}");
        }
    }
}
