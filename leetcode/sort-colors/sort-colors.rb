# LeetCode #75 - Sort Colors
# https://leetcode.com/problems/sort-colors/
# This is an O(1) auxiliary space solution to the Dutch national flag problem.

# Add checking color to integers.
class Integer
  def red?
    self == 0
  end

  def white?
    self == 1
  end

  def blue?
    self == 2
  end
end

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
    if nums[i].red?
      i += 1
    elsif nums[i].white?
      j -= 1
      nums[i], nums[j] = nums[j], nums[i]
    elsif nums[i].blue?
      j -= 1
      nums[i], nums[j] = nums[j], nums[i]
      k -= 1
      nums[j], nums[k] = nums[k], nums[j]
    else
      raise "Unrecognized color code #{nums[i]}"
    end
  end
end
