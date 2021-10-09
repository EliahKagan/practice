import math


class Solution:
    #Function to check whether a Binary Tree is BST or not.
    @staticmethod
    def isBST(root):
        stack = [(root, -math.inf, math.inf)]

        while stack:
            root, low, high = stack.pop()
            if not root:
                continue
            if not low < root.data < high:
                return False
            stack.append((root.left, low, root.data))
            stack.append((root.right, root.data, high))

        return True
