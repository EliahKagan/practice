// HackerRank - Median Updates
// https://www.hackerrank.com/challenges/median
// In Java 8, because that's what HackerRank supports. The problem is intended
// to be solved with self-balancing trees, but this solution uses binary heaps
// equipped with an O(log(n)) remove operation.

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Pattern;

/**
 * A priority queue with an O(log(n)) remove operation.
 * <p>
 *   Implemented as a binary heap augmented with a table mapping each key to
 *   all of its occurrences in the heap.
 * </p>
 **/
final class BinaryHeap<E> {
    static <E extends Comparable<E>> BinaryHeap<E> makeMinHeap() {
        return new BinaryHeap<>(Comparator.naturalOrder());
    }

    static <E extends Comparable<E>> BinaryHeap<E> makeMaxHeap() {
        return new BinaryHeap<>(Collections.reverseOrder());
    }

    boolean isEmpty() {
        return _heap.isEmpty();
    }

    int size() {
        return _heap.size();
    }

    void clear() {
        _heap.clear();
        _map.clear();
    }

    void push(E value) {
        _heap.add(null);
        int child = siftUp(value);
        _map.computeIfAbsent(value, val -> new HashSet<>()).add(child);
        _heap.set(child, value);
    }

    E pop() {
        E value = peek();

        if (size() == 1) {
            clear();
        } else {
            _map.computeIfPresent(value, (val, indices) -> {
                if (indices.size() == 1) {
                    return null; // Remove the mapping.
                } else {
                    indices.remove(0); // Remove the index from the mapped set.
                    return indices; // Keep the mapping.
                }
            });

            cutRoot();
        }

        return value;
    }

    E peek() {
        return _heap.get(0);
    }

    boolean remove(E value) {
        Set<Integer> indices = _map.get(value);
        if (indices == null) return false;

        if (size() == 1) {
            clear();
        } else {
            // Get any index to this value in the heap.
            int child = indices.iterator().next();

            if (indices.size() == 1) {
                _map.remove(value); // Remove the mapping.
            } else {
                child = highestEqualAncestor(child);
                indices.remove(child); // Remove the index from the mapped set.
            }

            yankUp(child);
            cutRoot();
        }

        return true;
    }

    private static final int NO_CHILD = -1;

    private BinaryHeap(Comparator<? super E> comp) {
        _comp = comp;
    }

    private void cutRoot() {
        int last = size() - 1;
        E value = _heap.get(last);
        _heap.remove(last); // Remove the item whose index is last.

        Set<Integer> indices = _map.get(value);
        indices.remove(last); // Remove the item comparing equal to last.

        int index = siftDown(value);
        indices.add(index);
        _heap.set(index, value);
    }

    private int highestEqualAncestor(int child) {
        E value = _heap.get(child);

        while (child != 0) {
            int parent = (child - 1) / 2;
            if (!_heap.get(parent).equals(value)) break;
            child = parent;
        }

        return child;
    }

    private void yankUp(int child) {
        while (child != 0) {
            int parent = (child - 1) / 2;
            E parentValue = _heap.get(parent);

            Set<Integer> indices = _map.get(parentValue);
            indices.remove(parent);
            indices.add(child);
            _heap.set(child, parentValue);

            child = parent;
        }
    }

    private int siftUp(E childValue) {
        int child = size() - 1;

        while (child != 0) {
            int parent = (child - 1) / 2;
            E parentValue = _heap.get(parent);
            if (orderOk(parentValue, childValue)) break;

            Set<Integer> indices = _map.get(parentValue);
            indices.remove(parent);
            indices.add(child);
            _heap.set(child, parentValue);

            child = parent;
        }

        return child;
    }

    private int siftDown(E parentValue) {
        int parent = 0;

        for (; ; ) {
            int child = pickChild(parent);
            if (child == NO_CHILD) break;
            E childValue = _heap.get(child);
            if (orderOk(parentValue, childValue)) break;

            Set<Integer> indices = _map.get(childValue);
            indices.remove(child);
            indices.add(parent);
            _heap.set(parent, childValue);

            parent = child;
        }

        return parent;
    }

    private int pickChild(int parent) {
        int left = parent * 2 + 1;
        if (left >= size()) return NO_CHILD;

        int right = left + 1;
        return right == size() || orderOk(_heap.get(left), _heap.get(right))
                ? left
                : right;
    }

    private boolean orderOk(E parentValue, E childValue) {
        return _comp.compare(parentValue, childValue) <= 0;
    }

    private final Map<E, Set<Integer>> _map = new HashMap<>();

    private final List<E> _heap = new ArrayList<>();

    private final Comparator<? super E> _comp;
}

final class MedianBag {
    boolean isEmpty() {
        return _low.isEmpty() && _high.isEmpty();
    }

    void add(int value) {
        if (!_low.isEmpty() && value < _low.peek())
            _low.push(value);
        else
            _high.push(value);

        rebalance();
    }

    boolean remove(int value) {
        if (_low.remove(value) || _high.remove(value)) {
            rebalance();
            return true;
        }

        return false;
    }

    double median() {
        switch (balanceFactor()) {
        case -1:
            return _low.peek();

        case +1:
            return _high.peek();

        case 0:
            return ((double)_low.peek() + (double)_high.peek()) / 2.0;

        default:
            throw new AssertionError("Bug: balancing invariant violated");
        }
    }

    private void rebalance() {
        switch (balanceFactor()) {
        case -2:
            _high.push(_low.pop());
            break;

        case +2:
            _low.push(_high.pop());
            break;

        default:
            break; // Can't be made more balanced.
        }
    }

    private int balanceFactor() {
        return _high.size() - _low.size();
    }

    private final BinaryHeap<Integer> _low = BinaryHeap.makeMaxHeap();

    private final BinaryHeap<Integer> _high = BinaryHeap.makeMinHeap();
}

enum Solution {
    ;

    public static void main(String[] args) throws IOException {
        MedianBag bag = new MedianBag();

        try (Reader isr = new InputStreamReader(System.in);
             BufferedReader br = new BufferedReader(isr)) {
            for (int count = readValue(br); count > 0; --count) {
                String[] tokens = readTokens(br);
                char opcode = tokens[0].charAt(0);
                int argument = Integer.parseInt(tokens[1]);

                switch (opcode) {
                case 'a':
                    bag.add(argument);
                    break;

                case 'r':
                    if (!bag.remove(argument) || bag.isEmpty()) {
                        System.out.println("Wrong!");
                        continue;
                    }
                    break;

                default:
                    break; // Ignore unrecognized opcodes.
                }

                printWithoutTrailingFractionalZero(bag.median());
            }
        }
    }

    private static void printWithoutTrailingFractionalZero(double value) {
        int roundedValue = (int)value;

        if (value == roundedValue)
            System.out.println(roundedValue);
        else
            System.out.println(value);
    }

    private static int readValue(BufferedReader br) throws IOException {
        return Integer.parseInt(br.readLine());
    }

    private static String[] readTokens(BufferedReader br) throws IOException {
        return WHITESPACE.split(br.readLine().stripLeading());
    }

    private static final Pattern WHITESPACE = Pattern.compile("\\s+");
}
