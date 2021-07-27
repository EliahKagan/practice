# LeetCode #18 - 4Sum
# https://leetcode.com/problems/4sum/
# By solving sorted 2Sum, via two-pointer method, for every (nonleading) pair.

# @param {Integer[]} nums
# @param {Integer} target
# @return {Integer[][]}
def four_sum(nums, target)
  ret = []
  n_sum(nums.sort!, 4, 0, target) { |quad| ret << quad }
  ret
end

def n_sum(nums, n, start, target)
  if n == 2
    two_sum(nums, start, target) { |pair| yield pair }
    return
  end

  cur = nil

  start.upto(nums.size - n) do |i|
    next if nums[i] == cur

    cur = nums[i]

    n_sum(nums, n - 1, i + 1, target - cur) do |tuple|
      yield tuple.unshift(cur)
    end
  end

  nil
end

def two_sum(nums, left, target)
  right = nums.size - 1

  while left < right
    first = nums[left]
    second = nums[right]
    sum = first + second

    yield [first, second] if sum == target

    if sum <= target
      left += 1 while left < right && nums[left] == first
    end

    if sum >= target
      right -= 1 while left < right && nums[right] == second
    end
  end
end
