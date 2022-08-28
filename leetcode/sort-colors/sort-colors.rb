# LeetCode #75 - Sort Colors
# https://leetcode.com/problems/sort-colors/
# This is an O(1) auxiliary space solution to the Dutch national flag problem.

RED = 0
WHITE = 1
BLUE = 2

# @param {Integer[]} nums
# @return {Void} Do not return anything, modify nums in-place instead.
def sort_colors(nums)
  # nums[0...i] are known red.
  # nums[i...j] are of unknown color.
  # nums[j...k] are known white.
  # nums[k...nums.size] are known blue.
  i = 0
  j = k = nums.size

  while i < j
    case nums[i]
    when RED
      i += 1
    when WHITE
      j -= 1
      nums[i], nums[j] = nums[j], nums[i]
    when BLUE
      j -= 1
      nums[i], nums[j] = nums[j], nums[i]
      k -= 1
      nums[j], nums[k] = nums[k], nums[j]
    else
      raise "Unrecognized color code #{nums[i]}"
    end
  end
end
