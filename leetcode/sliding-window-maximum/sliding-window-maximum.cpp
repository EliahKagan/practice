// LeetCode #239: Sliding Window Maximum
// https://leetcode.com/problems/sliding-window-maximum/
// Using a self-balancing binary search tree holding the window's contents.

class Solution {
public:
    [[nodiscard]] static vector<int>
    maxSlidingWindow(const vector<int>& nums, int k) noexcept;
};

vector<int>
Solution::maxSlidingWindow(const vector<int>& nums, const int k) noexcept
{
    auto left = cbegin(nums);
    auto right = left + k;

    auto window = multiset(left, right);
    auto best_max = *crbegin(window);
    auto best_left = left;

    for (const auto stop = cend(nums); right != stop; ++left, ++right) {
        window.erase(window.find(*left));
        window.insert(*right);

        const auto current_max = *crbegin(window);

        if (best_max < current_max) {
            best_max = current_max;
            best_left = left + 1;
        }
    }

    return vector(best_left, best_left + k);
}
