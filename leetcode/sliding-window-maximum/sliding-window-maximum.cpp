// LeetCode #239: Sliding Window Maximum
// https://leetcode.com/problems/sliding-window-maximum/
// Using a self-balancing binary search tree holding the window's contents.
// Takes O(n log k) time.

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

    auto maxima = vector<int>{};
    maxima.reserve(size(nums) - k + 1);
    maxima.push_back(*crbegin(window));

    for (const auto stop = cend(nums); right != stop; ++left, ++right) {
        window.erase(window.find(*left));
        window.insert(*right);
        maxima.push_back(*crbegin(window));
    }

    return maxima;
}
