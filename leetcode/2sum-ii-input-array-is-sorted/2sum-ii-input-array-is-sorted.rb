# LeetCode #167 - Two Sum II - Input array is sorted
# https://leetcode.com/problems/two-sum-ii-input-array-is-sorted/
# By two-pointer method.

# @param {Integer[]} numbers
# @param {Integer} target
# @return {Integer[]}
def two_sum(numbers, target)
  left = 0
  right = numbers.size - 1

  while left < right
    sum = numbers[left] + numbers[right]

    if sum < target
      left += 1
    elsif sum > target
      right -= 1
    else
      return [left + 1, right + 1]
    end
  end

  nil
end
