// Jim and his LAN Party
// https://www.hackerrank.com/challenges/jim-and-his-lan-party
// In C++14.

#include <algorithm>
#include <cassert>
#include <cstdlib>
#include <iostream>
#include <iterator>
#include <memory>
#include <numeric>
#include <unordered_map>
#include <utility>
#include <vector>

namespace {
    void ensure(const bool condition) noexcept
    {
        if (!condition) std::abort();
    }

    constexpr auto not_connected = -1;

    // A network of elements representing users or machiens, each of whom is a
    // member of exactly one group, which can meet/play when all members are
    // connected in a component (possibly shared with members of other groups).
    class Network {
    public:
        // Creates a new network with groups in [0, group_count) and elements
        // in [0, element_groups.size()). Element i is a member of
        // element_groups[i].
        Network(int group_count,
                const std::vector<int>& element_groups) noexcept;

        // Retrieves the times at which each group finished becoming connected.
        // For groups that were never connected, not_connected is returned.
        const std::vector<int>& completion_times() const noexcept;

        // Adds an edge/wire connecting elem1 and elem2.
        void connect(int elem1, int elem2) noexcept;

    private:
        using Contrib = std::unordered_map<int, int>;

        struct ConstructorParametersAreValid { };

        static int validate_parameters_and_return_group_count(
                int group_count,
                const std::vector<int>& element_groups) noexcept;

        static std::unique_ptr<Contrib>
        singleton_contribution(int group) noexcept;

        Network(ConstructorParametersAreValid,
                int group_count,
                const std::vector<int> &element_groups) noexcept;

        void set_initial_group_sizes(
                const std::vector<int>& element_groups) noexcept;

        void set_initial_group_completion_times() noexcept;

        void set_initial_elem_contributions(
                const std::vector<int>& element_groups) noexcept;

        void set_initial_elem_parents() noexcept;

        // Union-find "findset" operation with full path compression.
        int find_set(int elem) noexcept;

        // Makes child a child of parent and merges contributions into parent.
        void join(int parent, int child) noexcept;

        // Merges contributions into whichever contribution map started out
        // larger, recording and removing items that become complete as a
        // result. Returns a handle to the resulting hash, or an empty handle
        // if that has is ultimately empty.
        std::unique_ptr<Contrib>
        merge_contributions(std::unique_ptr<Contrib> contrib1,
                            std::unique_ptr<Contrib> contrib2) noexcept;

        // Merges source into sink. Helper for merge_contributions.
        std::unique_ptr<Contrib>
        do_merge_contributions(std::unique_ptr<Contrib> sink,
                               std::unique_ptr<Contrib> source) noexcept;

        std::vector<int> group_sizes_;
        std::vector<int> group_completion_times_;
        std::vector<std::unique_ptr<Contrib>> elem_contributions_;
        std::vector<int> elem_parents_;
        std::vector<int> elem_ranks_;
        int time_ {0};
    };

    Network::Network(const int group_count,
                     const std::vector<int> &element_groups) noexcept
        : Network{ConstructorParametersAreValid{},
                  validate_parameters_and_return_group_count(group_count,
                                                             element_groups),
                  element_groups}
    {
    }

    const std::vector<int>& Network::completion_times() const noexcept
    {
        return group_completion_times_;
    }

    void Network::connect(int elem1, int elem2) noexcept
    {
        ++time_;

        // Find the ancestors and stop if they are already the same.
        elem1 = find_set(elem1);
        elem2 = find_set(elem2);
        if (elem1 == elem2) return;

        // Union by rank, merging contributions.
        if (elem_ranks_[elem1] < elem_ranks_[elem2]) {
            join(elem2, elem1);
        } else {
            if (elem_ranks_[elem1] == elem_ranks_[elem2]) ++elem_ranks_[elem1];
            join(elem1, elem2);
        }
    }

    int Network::validate_parameters_and_return_group_count(
            const int group_count,
            const std::vector<int>& element_groups) noexcept
    {
        ensure(group_count >= 0);

        ensure(std::all_of(cbegin(element_groups), cend(element_groups),
                           [group_count](const auto group) noexcept {
            return 0 <= group && group < group_count;
        }));

        return group_count;
    }

    auto Network::singleton_contribution(int group) noexcept
            -> std::unique_ptr<Contrib>
    {
        auto contrib = std::make_unique<Contrib>();
        contrib->emplace(group, 1);
        return contrib;
    }

    Network::Network(ConstructorParametersAreValid,
                     const int group_count,
                     const std::vector<int>& element_groups) noexcept
        : group_sizes_(group_count, 0), // Values populated in body.
          group_completion_times_(group_count),
          elem_contributions_(element_groups.size()),
          elem_parents_(element_groups.size()),
          elem_ranks_(element_groups.size(), 0) // Elements start at rank 0.
    {
        set_initial_group_sizes(element_groups);
        set_initial_group_completion_times();
        set_initial_elem_contributions(element_groups);
        set_initial_elem_parents();
    }

    void Network::set_initial_group_sizes(
            const std::vector<int>& element_groups) noexcept
    {
        for (const auto group : element_groups) ++group_sizes_[group];
    }

    void Network::set_initial_group_completion_times() noexcept
    {
        std::transform(cbegin(group_sizes_), cend(group_sizes_),
                begin(group_completion_times_), [&](const auto size) noexcept {
            return size < 2 ? time_ : not_connected;
        });
    }

    void Network::set_initial_elem_contributions(
            const std::vector<int>& element_groups) noexcept
    {
        std::transform(cbegin(element_groups), cend(element_groups),
                begin(elem_contributions_), [&](const auto group) noexcept {
            return group_completion_times_[group] == not_connected
                    ? singleton_contribution(group)
                    : nullptr;
        });
    }

    void Network::set_initial_elem_parents() noexcept
    {
        std::iota(begin(elem_parents_), end(elem_parents_), 0);
    }

    int Network::find_set(int elem) noexcept
    {
        ensure(0 <= elem && elem < elem_parents_.size());

        // Find the ancestor.
        auto leader = elem;
        while (leader != elem_parents_[leader]) leader = elem_parents_[leader];

        // Compress the path.
        while (elem != leader) {
            const auto parent = elem_parents_[elem];
            elem_parents_[elem] = leader;
            elem = parent;
        }

        return leader;
    }

    void Network::join(int parent, int child) noexcept
    {
        elem_parents_[child] = parent;

        elem_contributions_[parent] =
            merge_contributions(std::move(elem_contributions_[parent]),
                                std::move(elem_contributions_[child]));
    }

    auto
    Network::merge_contributions(std::unique_ptr<Contrib> contrib1,
                                 std::unique_ptr<Contrib> contrib2) noexcept
            -> std::unique_ptr<Contrib>
    {
        // If either or both are null, there is nothing to do.
        if (!contrib1) return contrib2;
        if (!contrib2) return contrib1;

        // Merge to the bigger one (so we loop over the smaller).
        return contrib1->size() < contrib2->size()
                ? do_merge_contributions(std::move(contrib2),
                                         std::move(contrib1))
                : do_merge_contributions(std::move(contrib1),
                                         std::move(contrib2));
    }

    auto
    Network::do_merge_contributions(std::unique_ptr<Contrib> sink,
                                    std::unique_ptr<Contrib> source) noexcept
            -> std::unique_ptr<Contrib>
    {
        for (const auto& entry : *source) {
            const auto group = entry.first;
            const auto source_count = entry.second;
            const auto sink_pos = sink->find(group);

            if (sink_pos == sink->end()) {
                sink->emplace(group, source_count);
                continue;
            }

            auto& sink_count = sink_pos->second;

            if (sink_count + source_count < group_sizes_[group]) {
                sink_count = sink_count + source_count;
            } else {
                sink->erase(sink_pos);
                group_completion_times_[group] = time_;
            }
        }

        if (sink->empty()) return nullptr;
        return sink;
    }

    // Reads each player's game. Prepends a 0 for 1-based indexing.
    std::vector<int> read_player_games(const int player_count) noexcept
    {
        ensure(player_count > 0);

        auto element_groups = std::vector<int>(player_count + 1);

        std::copy_n(std::istream_iterator<int>(std::cin), player_count,
                    std::next(begin(element_groups)));

        return element_groups;
    }

    // Skip the extra 0 group and print other groups' completion times.
    void print_game_times(const Network& network) noexcept
    {
        const auto &times = network.completion_times();

        assert(!times.empty());

        std::copy(std::next(cbegin(times)), cend(times),
                  std::ostream_iterator<int>{std::cout, "\n"});
    }
}

int main()
{
    std::ios_base::sync_with_stdio(false);

    // Read the problem parameters.
    auto player_count = -1, game_count = -1, wire_count = -1;
    std::cin >> player_count >> game_count >> wire_count;

    // Check them against problem constraint lower-bounds.
    // (This is more stringent than the UB-avoiding checks Network does.)
    ensure(player_count > 0);
    ensure(game_count > 0);
    ensure(wire_count >= 0);

    // Make the LAN.
    auto network = Network{game_count + 1, // +1 for 1-based indexing
                           read_player_games(player_count)};

    // Apply all the connections.
    while (wire_count-- > 0) {
        auto elem1 = int{}, elem2 = int{};
        std::cin >> elem1 >> elem2;
        network.connect(elem1, elem2);
    }

    print_game_times(network);
}
