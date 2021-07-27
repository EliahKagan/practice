# LeetCode #15 - 3Sum
# https://leetcode.com/problems/3sum/
# By two pointers, repeated for each suffix, with hash-based duplicate removal.

# @param {Integer[]} nums
# @return {Integer[][]}
def three_sum(nums)
  nums.sort!
  triplets = []

  while nums.size > 2
    first = nums.shift
    pairs = two_sum(nums, -first)
    triplets.concat(pairs.each { |pair| pair.unshift(first) })
  end

  triplets.uniq
end

def two_sum(nums, target)
  pairs = []

  left = 0
  right = nums.size - 1

  while left < right
    sum = nums[left] + nums[right]

    pairs << [nums[left], nums[right]] if sum == target
    left += 1 if sum <= target
    right -= 1 if sum >= target
  end

  pairs
end
