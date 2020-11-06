// Snakes and Ladders: The Quickest Way Up
// https://www.hackerrank.com/challenges/the-quickest-way-up

import java.util.ArrayDeque;
import java.util.OptionalInt;
import java.util.Queue;
import java.util.Scanner;
import java.util.stream.IntStream;

/** A "Snakes and Ladders" board and die. */
final class Game {
    /** Creates a new board of the specified size and die reach. */
    Game(int size, int maxReach) {
        _board = IntStream.rangeClosed(0, size).toArray();
        _maxReach = maxReach;
    }

    /** Adds a snake or ladder from {@code src} to {@code dest}.
     * (1-based indexing.) */
    void addSnakeOrLadder(int src, int dest) {
        checkIndex(src);
        checkIndex(dest);

        _board[src] = dest;
    }

    /** Computes the minimum distance from start to finish via BFS. */
    OptionalInt computeDistance(int start, int finish) {
        checkIndex(start);
        checkIndex(finish);

        boolean[] vis = new boolean[_board.length];
        vis[start] = true;
        Queue<Integer> queue = new ArrayDeque<>();
        queue.add(start);
        int distance = 0;

        while (!queue.isEmpty()) {
            ++distance;

            for (int breadth = queue.size(); breadth > 0; --breadth) {
                int src = queue.remove();
                for (int dest : _destinations(src)) {
                    if (vis[dest]) continue;
                    vis[dest] = true;
                    if (dest == finish) return OptionalInt.of(distance);
                    queue.add(dest);
                }
            }
        }

        return OptionalInt.empty();
    }

    private void checkIndex(int position) {
        if (!(0 < position && position < _board.length))
            throw new IllegalArgumentException("position is off the board");
    }

    /** Computes destinations from a give source position.
     * This accounts for the traversal of snakes and ladders. */
    private int[] _destinations(int src) {
        int startInclusive = src + 1;
        int endExclusive = Math.min(startInclusive + _maxReach, _board.length);

        return IntStream.range(startInclusive, endExclusive)
                        .map(predest -> _board[predest])
                        .toArray();
    }

    private final int[] _board;

    private final int _maxReach;
}

enum Solution {
    ;

    public static void main(String[] args) {
        try (Scanner sc = new Scanner(System.in)) {
            for (int runCount = sc.nextInt(); runCount > 0; --runCount)
                run(sc);
        }
    }

    /** Reads a board configuration and reports the BFS distance. */
    private static void run(Scanner sc) {
        Game game = new Game(100, 6);
        readSnakesOrLadders(game, sc); // ladders
        readSnakesOrLadders(game, sc); // snakes
        System.out.println(game.computeDistance(1, 100).orElse(-1));
    }

    /** Adds snakes or ladders in the input format of the game. */
    private static void readSnakesOrLadders(Game game, Scanner sc) {
        for (int edgeCount = sc.nextInt(); edgeCount > 0; --edgeCount) {
            int src = sc.nextInt();
            int dest = sc.nextInt();
            game.addSnakeOrLadder(src, dest);
        }
    }
}
