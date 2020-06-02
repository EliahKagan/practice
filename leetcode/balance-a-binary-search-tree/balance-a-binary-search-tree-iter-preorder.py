# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
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

def balanced_bst_from(values):
    """
    Builds a balanced BST from a list, which is presumed to be sorted.
    The tree is built in an iterative (preorder) fashion, even though a
    recursive approach wouldn't overflow the stack as the tree is balanced.
    """
    stack = []
    def push(low, high):
        if low >= high:
            return None
        node = TreeNode()
        stack.append((low, high, node))
        return node

    root = push(0, len(values))
    while stack:
        low, high, node = stack.pop()
        mid = (low + high) // 2
        node.val = values[mid]
        node.left = push(low, mid)
        node.right = push(mid + 1, high)

    return root
