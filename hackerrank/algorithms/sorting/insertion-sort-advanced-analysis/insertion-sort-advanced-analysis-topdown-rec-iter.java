// HackerRank: Insertion Sort Advanced Analysis
// https://www.hackerrank.com/challenges/insertion-sort/
// By instrumenting iteratively implemented recursive top-down mergesort.

import java.util.ArrayDeque;
import java.util.Collections;
import java.util.Scanner;

/** Index-range type for implementing top-down mergesort iteratively. */
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

/**
 * State-machine states for implementing recursive top-down mergesort
 * iteratively.
 */
enum Action { GO_LEFT, GO_RIGHT, RETREAT }

/**
 * Stack frame for implementing recursive top-down mergesort iteratively with a
 * state machine.
 */
final class Frame {
    Frame(int low, int high) {
        range = new Range(low, high);
        action = Action.GO_LEFT;
    }

    final Range range;

    Action action;
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
        var stack = Collections.asLifoQueue(new ArrayDeque<Frame>());

        for (stack.add(new Frame(0, values.length)); !stack.isEmpty(); ) {
            var frame = stack.element();

            switch (frame.action) {
            case GO_LEFT:
                if (frame.range.size() < 2) {
                    stack.remove();
                    continue;
                }

                frame.action = Action.GO_RIGHT;
                stack.add(new Frame(frame.range.low(), frame.range.mid()));
                continue;

            case GO_RIGHT:
                frame.action = Action.RETREAT;
                stack.add(new Frame(frame.range.mid(), frame.range.high()));
                continue;

            case RETREAT:
                count += merge(values,
                               frame.range.low(),
                               frame.range.mid(),
                               frame.range.high(),
                               aux);
                stack.remove();
                continue;
            }

            throw new AssertionError("state is unrecognized or null");
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
