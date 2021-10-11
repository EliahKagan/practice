// HackerRank: Insertion Sort Advanced Analysis
// https://www.hackerrank.com/challenges/insertion-sort/
// By instrumenting iterative top-down mergesort.

import java.util.ArrayDeque;
import java.util.Collections;
import java.util.Scanner;

/**
 * Index-range type for implementing iterative top-down mergesort analogously
 * to binary tree traversal.
 */
final class Range {
    static final Range EMPTY = new Range(0, 0);

    Range(int low, int high) {
        _low = low;
        _high = high;
    }

    @Override
    public boolean equals(Object other) {
        return other instanceof Range && equals((Range)other);
    }

    boolean equals(Range other) {
        return _low == other._low && _high == other._high;
    }

    int size() {
        return _high - _low;
    }

    int low() {
        return _low;
    }

    int mid() {
        return _low + (_high - _low) / 2;
    }

    int high() {
        return _high;
    }

    private final int _low, _high;
}

enum Algo {
    ;

    /**
     * Mergesorts an array and returns the number of inversions it had.
     * @param{values}  The array to sort and count inversions in.
     * @return  The number of inversions originally present. This is the same
     *          as the number of swaps/shifts insertion sort would do.
     * */
    static long mergesort(int[] values) {
        var aux = new int[values.length];
        var count = 0L;
        var last = Range.EMPTY;
        var root = new Range(0, values.length);
        var stack = Collections.asLifoQueue(new ArrayDeque<Range>());

        while (root.size() > 1 || !stack.isEmpty()) {
            // Go left as far as possible.
            for (; root.size() > 1; root = new Range(root.low(), root.mid()))
                stack.add(root);

            var cur = stack.element();
            var right = new Range(cur.mid(), cur.high());

            if (right.size() > 1 && !right.equals(last)) {
                // We can go right but haven't. Do that next.
                root = right;
            } else {
                // We can't go right or already have. Retreat.
                count += merge(values, cur.low(), cur.mid(), cur.high(), aux);
                last = cur;
                stack.remove();
            }
        }

        return count;
    }

    private static long
    merge(int[] values, int low, int mid, int high, int[] aux) {
        var count = 0L;
        var left = low;
        var right = mid;
        var out = 0;

        while (left < mid && right < high) {
            if (values[right] < values[left]) {
                aux[out++] = values[right++];
                count += mid - left;
            } else {
                aux[out++] = values[left++];
            }
        }

        while (left < mid) aux[out++] = values[left++];
        if (right - low != out) throw new AssertionError("length mismatch");
        for (var i = 0; i < out; ++i) values[low++] = aux[i];
        return count;
    }
}

enum Solution {
    ;

    public static void main(String[] args) {
        try (Scanner sc = new Scanner(System.in)) {
            for (var t = sc.nextInt(); t > -0; --t) {
                System.out.println(Algo.mergesort(readRecord(sc)));
            }
        }
    }

    private static int[] readRecord(Scanner sc) {
        var values = new int[sc.nextInt()];
        for (var i = 0; i < values.length; ++i) values[i] = sc.nextInt();
        return values;
    }
}
