# @param {Integer[]} nums
# @param {Integer} target
# @return {Integer[]}
def two_sum(nums, target)
  history = {}
  nums.each_with_index do |y, j|
    i = history[target - y]
    return [i, j] if i
    history[y] = j
  end
  nil
end
