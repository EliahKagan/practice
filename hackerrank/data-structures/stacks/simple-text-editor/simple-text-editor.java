// https://www.hackerrank.com/challenges/simple-text-editor
// In Java 8, since that's what HackerRank supports.

import java.util.ArrayDeque;
import java.util.Deque;
import java.util.Scanner;

/** Text buffer supporting appending and truncation, with undo capability. */
final class Editor {
    void append(String text) {
        int index = _buffer.length();
        _buffer.append(text);
        _undos.push(() -> _buffer.setLength(index));
    }

    void delete(int count) {
        int index = _buffer.length() - count;
        String text = _buffer.substring(index);
        _buffer.setLength(index);
        _undos.push(() -> _buffer.append(text));
    }

    void print(int index) {
        System.out.println(_buffer.charAt(index - 1));
    }

    void undo() {
        _undos.pop().run();
    }
    
    private final StringBuilder _buffer = new StringBuilder();

    private final Deque<Runnable> _undos = new ArrayDeque<>();
}

enum Solution {
    ;

    public static void main(String[] args) {
        Editor editor = new Editor();

        try (Scanner sc = new Scanner(System.in)) {
            for (int q = sc.nextInt(); q > 0; --q) {
                switch (sc.nextInt()) {
                case 1:
                    editor.append(sc.next());
                    break;

                case 2:
                    editor.delete(sc.nextInt());
                    break;

                case 3:
                    editor.print(sc.nextInt());
                    break;

                case 4:
                    editor.undo();
                    break;
                }
            }
        }
    }
}
