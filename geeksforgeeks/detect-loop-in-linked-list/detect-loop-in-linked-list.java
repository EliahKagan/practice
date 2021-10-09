class Solution {
    //Function to check if the linked list has a loop.
    public static boolean detectLoop(Node head) {
        if (head == null) return false;

        var fast = head;
        while (fast.next != null) {
            fast = fast.next.next;
            if (fast == null) break;

            head = head.next;
            if (head == fast) return true;
        }

        return false;
    }
}
