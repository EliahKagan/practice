# LeetCode #2126 - Destroying Asteroids
# https://leetcode.com/problems/destroying-asteroids/

# @param {Integer} mass
# @param {Integer[]} asteroids
# @return {Boolean}
def asteroids_destroyed(mass, asteroids)
  asteroids.sort.each do |delta|
    return false if mass < delta

    mass += delta
  end

  true
end
