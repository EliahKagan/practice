# https://leetcode.com/problems/find-a-corresponding-node-of-a-binary-tree-in-a-clone-of-that-tree

# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None


def _go_left(node: TreeNode) -> TreeNode:
    """Gets the left child of a node."""
    return node.left


def _go_right(node: TreeNode) -> TreeNode:
    """Gets the right child of a node."""
    return node.right


class _Found(Exception):
    """Helper exception for _find_path."""
    __slots__ = ()


def _find_path(root: TreeNode, target: TreeNode):
    """Gets a list of actions to navigate from root to target."""
    moves = []

    def dfs(node):
        if node is None:
            return

        if node is target:
            raise _Found()

        for move in _go_left, _go_right:
            moves.append(move)
            dfs(move(node))
            del moves[-1]

    try:
        dfs(root)
    except _Found:
        return moves

    return None


def _follow_path(root: TreeNode, moves) -> TreeNode:
    """Runs a list of actions to navigate from root to a target."""
    for move in moves:
        root = move(root)

    return root


class Solution:
    def getTargetCopy(self,
                      original: TreeNode,
                      cloned: TreeNode,
                      target: TreeNode) -> TreeNode:
        """
        Navigates to a node under cloned that corresponds to target under
        original. Assumes cloned is (at least structurally) a clone of
        original.
        """
        moves = _find_path(original, target)
        if moves is None:
            return None
        return _follow_path(cloned, moves)
