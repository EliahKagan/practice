# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right

import enum


class Solution:
    def balanceBST(self, root: TreeNode) -> TreeNode:
        """Creates a new balanced BST with the values of the tree at root."""
        return balanced_bst_from(list(inorder(root)))

def inorder(root):
    """Inorder traversal, yielding values held in nodes."""
    stack = []
    while root or stack:
        # Go left as far as possible.
        while root:
            stack.append(root)
            root = root.left

        # Use the value at the current node.
        cur = stack.pop()
        yield cur.val

        # Go right if possible.
        root = cur.right


@enum.unique
class Action(enum.Enum):
    """
    Possible next actions to do, in iteratively implemented recursive traversal
    of a binary-tree-like structure.
    """
    GO_LEFT = enum.auto()
    GO_RIGHT = enum.auto()
    RETREAT = enum.auto()


class Frame:
    """
    A stack frame for iteratively implemented recursive traversal of a sorted
    array, treated as if it were a binary tree, being "copied" into an (actual)
    binary tree that is being newly created.
    """

    __slots__ = ('_low', '_high', 'action', 'left_node')

    def __init__(self, low, high, action):
        """Creates a frame for the range [low, high) and the given action."""
        self._low = low
        self._high = high
        self.action = action
        self.left_node = None

    @property
    def low(self):
        """Returns the lower end of the range for this frame."""
        return self._low

    @property
    def mid(self):
        """Computes the middle of the range for this frame."""
        return (self._low + self._high) // 2

    @property
    def high(self):
        """Returns the upper end of the range for this frame."""
        return self._high


def balanced_bst_from(values):
    """
    Builds a balanced BST from a list, which is presumed to be sorted.
    The tree is built in an iterative (postorder) fashion, even though a
    recursive approach wouldn't overflow the stack as the tree is balanced.
    (I call this "postorder" as output nodes are constructed when retreating,
    rather than when advancing. But it also has an inorder action: saving the
    root of the just-built left subtree.)
    """
    out = ...
    stack = [Frame(0, len(values), Action.GO_LEFT)]

    while stack:
        frame = stack[-1]

        if frame.action is Action.GO_LEFT:
            if frame.low == frame.high:
                out = None
                del stack[-1]
                continue

            assert frame.low < frame.high
            frame.action = Action.GO_RIGHT
            stack.append(Frame(frame.low, frame.mid, Action.GO_LEFT))
        elif frame.action is Action.GO_RIGHT:
            frame.action = Action.RETREAT
            frame.left_node = out
            stack.append(Frame(frame.mid + 1, frame.high, Action.GO_LEFT))
        else:
            assert frame.action is Action.RETREAT
            out = TreeNode(values[frame.mid], frame.left_node, out)
            del stack[-1]

    assert out != ...
    return out
