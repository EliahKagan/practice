import math


class Solution:
    #Function to check whether a Binary Tree is BST or not.
    @staticmethod
    def isBST(root):
        return is_bst_in_range(root, -math.inf, math.inf)


def is_bst_in_range(root, low, high):
    if not root:
        return True

    return (low < root.data < high
            and is_bst_in_range(root.left, low, root.data)
            and is_bst_in_range(root.right, root.data, high))
