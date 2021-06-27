# LeetCode #997 - Find the Town Judge
# https://leetcode.com/problems/find-the-town-judge/

# @param {Integer} n
# @param {Integer[][]} trust
# @return {Integer}
def find_judge(n, trust)
  outdegrees = [0] * (n + 1)
  indegrees = [0] * (n + 1)

  trust.each do |src, dest|
    outdegrees[src] += 1
    indegrees[dest] += 1
  end

  (1..n).find { |i| outdegrees[i].zero? && indegrees[i] == n - 1 } || -1
end
