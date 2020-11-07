// Snakes and Ladders: The Quickest Way Up
// https://www.hackerrank.com/challenges/the-quickest-way-up
// In C++14, via BFS on an implicit graph.

#include <algorithm>
#include <cassert>
#include <cstdlib>
#include <iostream>
#include <numeric>
#include <queue>
#include <tuple>
#include <vector>

namespace {
    inline void ensure(const bool condition)
    {
        if (!condition) std::abort();
    }

    // A "Snakes and Ladders" board and die.
    class Game {
    public:
        // Creates a new board of the specified size and die reach.
        Game(int size, int max_reach) noexcept;

        // Adds a snake or ladder from src to dest. (1-based indexing.)
        void add_snake_or_ladder(int src, int dest) noexcept;

        // Computes the minimum distance from start to finish via BFS.
        int compute_distance(int start, int finish) const noexcept;

        static constexpr auto unreachable = -1;

    private:
        // Terminates abnormally if the position is not of a valid board cell.
        void check_index(int position) const noexcept;

        // Computes the range of destinations from a given source position.
        // This accounts for the traversal of snakes and ladders.
        std::vector<int> destinations(int src) const noexcept;

        std::vector<int> board_;
        int max_reach_;
    };

    Game::Game(const int size, const int max_reach) noexcept
        : board_(size + 1), max_reach_{max_reach}
    {
        std::iota(begin(board_), end(board_), 0);
    }

    void Game::add_snake_or_ladder(const int src, const int dest) noexcept
    {
        check_index(src);
        check_index(dest);

        board_[src] = dest;
    }

    int
    Game::compute_distance(const int start, const int finish) const noexcept
    {
        check_index(start);
        check_index(finish);

        auto vis = std::vector<char>(board_.size(), false);
        vis[start] = true;
        auto queue = std::queue<int>{};
        queue.push(start);
        auto distance = 0;

        while (!queue.empty()) {
            ++distance;

            for (auto breadth = queue.size(); breadth != 0; --breadth) {
                const auto src = queue.front();
                queue.pop();

                for (const auto dest : destinations(src)) {
                    if (vis[dest]) continue;
                    vis[dest] = true;
                    if (dest == finish) return distance;
                    queue.push(dest);
                }
            }
        }

        return unreachable;
    }

    void Game::check_index(const int position) const noexcept
    {
        ensure(0 < position && position < board_.size());
    }

    std::vector<int> Game::destinations(const int src) const noexcept
    {
        const auto low = src + 1;
        const auto high = std::min(low + max_reach_,
                                   static_cast<int>(board_.size()));
        assert(low <= high);

        auto dests = std::vector<int>(high - low);
        std::iota(begin(dests), end(dests), low);
        assert(dests.empty() || dests.back() == high - 1);

        std::transform(cbegin(dests), cend(dests), begin(dests),
                [&](const auto predest) noexcept { return board_[predest]; });

        return dests;
    }

    // Adds snakes or ladders in the input format of the game.
    void read_snakes_or_ladders(Game& game) noexcept
    {
        auto edge_count = int{};
        for (std::cin >> edge_count; edge_count > 0; --edge_count) {
            auto src = int{}, dest = int{};
            std::cin >> src >> dest;
            game.add_snake_or_ladder(src, dest);
        }
    }

    // Reads a board configuration and reports the BFS distance.
    void run() noexcept
    {
        auto game = Game(100, 6);
        read_snakes_or_ladders(game); // ladders
        read_snakes_or_ladders(game); // snakes
        std::cout << game.compute_distance(1, 100) << '\n';
    }
}

int main()
{
    std::ios_base::sync_with_stdio(false);

    auto run_count = int{};
    for (std::cin >> run_count; run_count > 0; --run_count) run();
}
