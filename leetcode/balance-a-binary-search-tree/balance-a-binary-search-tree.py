# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
class Solution:
    def balanceBST(self, root: TreeNode) -> TreeNode:
        return balanced_bst_from(list(inorder(root)))

def inorder(root):
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

def balanced_bst_from(values):
    def subtree(low, high):
        if low >= high:
            return None
        mid = (low + high) // 2
        return TreeNode(values[mid], subtree(low, mid), subtree(mid + 1, high))

    return subtree(0, len(values))
