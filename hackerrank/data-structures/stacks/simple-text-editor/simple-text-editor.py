#!/usr/bin/env python3

"""
HackerRank - Simple Text Editor
https://www.hackerrank.com/challenges/simple-text-editor
naive approach, storing full snapshots
"""


class Editor:
    """
    Text buffer supporting appending and truncation, with undo capability.
    """

    __slots__ = ('_buffers',)

    def __init__(self):
        """Creates a new editor with an initially empty buffer."""
        self._buffers = [""]

    def append(self, text):
        """Saves a checkpoint and appends text to the buffer."""
        self._buffers.append(self._buffers[-1] + text)

    def delete(self, count):
        """Saves a checkpoint and truncates the buffer."""
        self._buffers.append(self._buffers[-1][:-count])

    def print(self, index):
        """Prints a (1-based) indexed character."""
        print(self._buffers[-1][index - 1])

    def undo(self):
        """Reverts the last append or delete."""
        del self._buffers[-1]


if __name__ == '__main__':
    editor = Editor()

    for _ in range(int(input())):
        tokens = input().split()
        opcode = int(tokens[0])

        if opcode == 1:
            editor.append(tokens[1])
        elif opcode == 2:
            editor.delete(int(tokens[1]))
        elif opcode == 3:
            editor.print(int(tokens[1]))
        elif opcode == 4:
            editor.undo()
