# LeetCode #15 - 3Sum
# https://leetcode.com/problems/3sum/
# By two pointers, repeated for each suffix, avoiding duplicates.

# @param {Integer[]} nums
# @return {Integer[][]}
def three_sum(nums)
  nums.sort!
  triplets = []

  while nums.size > 2
    first = nums.shift
    pairs = two_sum(nums, -first)
    triplets.concat(pairs.each { |pair| pair.unshift(first) })

    nums.shift while nums.first == first
  end

  triplets
end

def two_sum(nums, target)
  pairs = []

  left = 0
  right = nums.size - 1

  while left < right
    first = nums[left]
    second = nums[right]
    sum = first + second

    pairs << [first, second] if sum == target

    if sum <= target
      left += 1 while left < right && nums[left] == first
    end

    if sum >= target
      right -= 1 while left < right && nums[right] == second
    end
  end

  pairs
end
