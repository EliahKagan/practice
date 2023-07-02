// LeetCode #239: Sliding Window Maximum
// https://leetcode.com/problems/sliding-window-maximum/
// Discarding smaller elements that precede larger ones.
// This is also called a "monontonic queue." Takes O(n) time.

class Solution {
public:
    [[nodiscard]] static vector<int>
    maxSlidingWindow(const vector<int>& nums, int k) noexcept;
};

namespace {
    using It = vector<int>::const_iterator;
}

vector<int>
Solution::maxSlidingWindow(const vector<int>& nums, const int k) noexcept
{
    auto window = deque<It>{};

    const auto push = [&window](const It pos) noexcept {
        while (!empty(window) && *window.back() < *pos) window.pop_back();
        window.push_back(pos);
    };

    auto left = cbegin(nums);
    auto right = left;
    for (const auto stop = left + k; right != stop; ++right) push(right);

    auto maxima = vector<int>{};
    maxima.reserve(size(nums) - k + 1);
    maxima.push_back(*window.front());

    for (const auto stop = cend(nums); right != stop; ++left, ++right) {
        if (window.front() == left) window.pop_front();
        push(right);
        maxima.push_back(*window.front());
    }

    return maxima;
}
