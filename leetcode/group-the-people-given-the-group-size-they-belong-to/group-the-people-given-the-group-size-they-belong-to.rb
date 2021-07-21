# LeetCode #128 - Group the People Given the Group Size They Belong To
# https://leetcode.com/problems/group-the-people-given-the-group-size-they-belong-to/

# @param {Integer[]} group_sizes
# @return {Integer[][]}
def group_the_people(group_sizes)
  make_groups(invert(group_sizes))
end

def invert(group_sizes)
  inverse = {}

  group_sizes.each_with_index do |size, person|
    (inverse[size] ||= []) << person
  end

  inverse
end

def assert_divides(divisor, dividend)
  return if (dividend % divisor).zero?

  raise "#{divisor} doesn't divide #{dividend}"
end

def make_groups(inverse)
  groups = []

  inverse.each do |size, people|
    assert_divides(size, people.size)
    groups << people.shift(size) until people.empty?
  end

  groups
end
