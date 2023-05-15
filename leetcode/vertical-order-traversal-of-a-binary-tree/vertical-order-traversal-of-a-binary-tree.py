# LeetCode #987 - Vertical Order Traversal of a Binary Tree
# https://leetcode.com/problems/vertical-order-traversal-of-a-binary-tree/

from dataclasses import dataclass


# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right

class Solution:
    @staticmethod
    def verticalTraversal(root: Optional[TreeNode]) -> List[List[int]]:
        grouped = itertools.groupby(plot(root), lambda bubble: bubble.col)
        return [[bubble.val for bubble in group] for _, group in grouped]


@dataclass(frozen=True, slots=True, order=True)
class Bubble:
    col: int
    row: int
    val: int


def plot(root: Optional[TreeNode]) -> List[Bubble]:
    bubbles = []

    def dfs(node: Optional[TreeNode], col: int, row: int) -> None:
        if not node:
            return
        bubbles.append(Bubble(col, row, node.val))
        dfs(node.left, col - 1, row + 1)
        dfs(node.right, col + 1, row + 1)

    dfs(root, 0, 0)
    bubbles.sort()
    return bubbles
