// HackerRank - Find the Running Median
// https://www.hackerrank.com/challenges/find-the-running-median
// Using two heaps, of a type implemented here as an exercise.
// (Ordinarily, it would be better to use java.util.PriorityQueue.)

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.Iterator;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.Queue;
import java.util.Scanner;

final class Heap<E> implements Queue<E> {
    static <E extends Comparable<? super E>> Heap<E> minHeap() {
        return new Heap<>(Comparator.naturalOrder());
    }

    static <E extends Comparable<? super E>> Heap<E> maxHeap() {
        return new Heap<>(Collections.reverseOrder());
    }

    Heap(Comparator<? super E> comp) {
        _comp = comp;
    }

    @Override
    public boolean isEmpty() {
        return _heap.isEmpty();
    }

    @Override
    public int size() {
        return _heap.size();
    }

    @Override
    public void clear() {
        _heap.clear();
    }

    @Override
    public boolean add(E value) {
        _heap.add(value);
        siftUp(size() - 1);
        return true;
    }

    @Override
    public E remove() {
        E value = element();

        if (size() == 1) {
            clear();
        } else {
            _heap.set(0, _heap.remove(size() - 1));
            siftDown(0);
        }

        return value;
    }

    @Override
    public E element() {
        if (isEmpty()) {
            throw new NoSuchElementException(
                    "empty heap has no first element");
        }

        return _heap.get(0);
    }

    @Override
    public boolean offer(E value) {
        return add(value);
    }

    @Override
    public E poll() {
        return isEmpty() ? null : remove();
    }

    @Override
    public E peek() {
        return isEmpty() ? null : element();
    }

    @Override
    public boolean addAll(Collection<? extends E> collection) {
        for (E value : collection) add(value);
        return true;
    }

    @Override
    public boolean contains(Object value) {
        return _heap.contains(value);
    }

    @Override
    public boolean containsAll(Collection<?> collection) {
        return _heap.containsAll(collection);
    }

    @Override
    public Iterator<E> iterator() {
        return _heap.iterator();
    }

    @Override
    public boolean remove(Object value) {
        throw new UnsupportedOperationException();
    }

    @Override
    public boolean removeAll(Collection<?> collection) {
        throw new UnsupportedOperationException();
    }

    @Override
    public boolean retainAll(Collection<?> collection) {
        throw new UnsupportedOperationException();
    }

    @Override
    public Object[] toArray() {
        return _heap.toArray();
    }

    @Override
    public <T> T[] toArray(T[] array) {
        return _heap.toArray(array);
    }

    private static final int NO_CHILD = -1;

    private void siftUp(int child) {
        while (child != 0) {
            int parent = (child - 1) / 2;
            if (orderOk(parent, child)) break;

            swap(parent, child);
            child = parent;
        }
    }

    private void siftDown(int parent) {
        for (; ; ) {
            int child = pickChild(parent);
            if (child == NO_CHILD || orderOk(parent, child)) break;

            swap(parent, child);
            parent = child;
        }
    }

    private int pickChild(int parent) {
        int left = parent * 2 + 1;
        if (left >= size()) return NO_CHILD;

        int right = left + 1;
        return right == size() || orderOk(left, right) ? left : right;
    }

    private boolean orderOk(int parent, int child) {
        return _comp.compare(_heap.get(parent), _heap.get(child)) <= 0;
    }

    private void swap(int i, int j) {
        E tmp = _heap.get(i);
        _heap.set(i, _heap.get(j));
        _heap.set(j, tmp);
    }

    private final List<E> _heap = new ArrayList<>();

    private final Comparator<? super E> _comp;
}

final class MedianBag {
    void add(int value) {
        if (!_low.isEmpty() && value < _low.element())
            _low.add(value);
        else
            _high.add(value);

        rebalance();
    }

    double median() {
        switch (balanceFactor()) {
        case -1:
            return _low.element();

        case +1:
            return _high.element();

        case 0:
            return (_low.element() + _high.element()) / 2.0;

        default:
            throw new AssertionError("balancing invariant violated");
        }
    }

    private void rebalance() {
        switch (balanceFactor()) {
        case -2:
            _high.add(_low.remove());
            break;

        case +2:
            _low.add(_high.remove());
            break;

        default:
            break; // Can't be made more balanced.
        }
    }

    private int balanceFactor() {
        return _high.size() - _low.size();
    }

    private final Queue<Integer> _low = Heap.maxHeap();

    private final Queue<Integer> _high = Heap.minHeap();
}

enum Solution {
    ;

    public static void main(String[] args) {
        MedianBag bag = new MedianBag();

        try (Scanner sc = new Scanner(System.in)) {
            for (int count = sc.nextInt(); count > 0; --count) {
                bag.add(sc.nextInt());
                System.out.format("%.1f%n", bag.median());
            }
        }
    }
}
