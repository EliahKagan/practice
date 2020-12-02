# @param {Integer[]} nums
# @param {Integer} target
# @return {Integer[]}
def two_sum(nums, target)
  indexed = nums.each_with_index.sort

  left = 0
  right = nums.size - 1

  while left < right
    left_value, left_index = indexed[left]
    right_value, right_index = indexed[right]

    if left_value + right_value < target
      left += 1
    elsif left_value + right_value > target
      right -= 1
    else
      return [left_index, right_index]
    end
  end

  nil
end
