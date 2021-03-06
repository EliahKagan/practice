// HackerRank - Median Updates
// https://www.hackerrank.com/challenges/median
// In C++14, since that's what HackerRank supports. Uses a pair of B-tree
// multisets (absl::btree_multiset) analogously to the two-heap approach
// typically used to solve the easier problem (with insertion but not erasure).

#include <cmath>
#include <cstdlib>
#include <functional>
#include <iomanip>
#include <iostream>
#include <iterator>
#include <string>
#include <absl/container/btree_set.h>

namespace {
    template<typename T>
    using MinTree = absl::btree_multiset<T, std::less<>>;

    template<typename T>
    using MaxTree = absl::btree_multiset<T, std::greater<>>;

    template<typename Key, typename Compare, typename Allocator>
    inline const Key&
    first(const absl::btree_multiset<Key, Compare, Allocator>& multiset)
            noexcept
    {
        using std::cbegin;

        return *cbegin(multiset);
    }

    template<typename Key, typename Compare, typename Allocator>
    bool erase_one(absl::btree_multiset<Key, Compare, Allocator>& multiset,
                   const Key& key) noexcept
    {
        using std::end;

        const auto pos = multiset.find(key);
        if (pos == end(multiset)) return false;

        multiset.erase(pos);
        return true;
    }

    template<typename Key, typename Compare, typename Allocator>
    Key extract_first(absl::btree_multiset<Key, Compare, Allocator>& multiset)
            noexcept
    {
        using std::begin;

        const auto pos = begin(multiset);
        auto value = *pos;
        multiset.erase(pos);
        return value;
    }

    // A multiset with O(log(n)) insertion and deletion and O(1) median
    // finding.
    class MedianBag {
    public:
        bool empty() const noexcept;
        void insert(int value);
        bool erase(int value) noexcept;
        double median() const noexcept;

    private:
        void rebalance();
        long balance_factor() const noexcept;

        MaxTree<int> low_ {};
        MinTree<int> high_ {};
    };

    inline bool MedianBag::empty() const noexcept
    {
        return low_.empty() && high_.empty();
    }

    void MedianBag::insert(const int value)
    {
        if (!low_.empty() && value < first(low_))
            low_.insert(value);
        else
            high_.insert(value);

        rebalance();
    }

    bool MedianBag::erase(const int value) noexcept
    {
        if (erase_one(low_, value) || erase_one(high_, value)) {
            rebalance();
            return true;
        }

        return false;
    }

    double MedianBag::median() const noexcept
    {
        switch (balance_factor()) {
        case -1:
            return first(low_);

        case +1:
            return first(high_);

        case 0:
            return (static_cast<double>(first(high_))
                    + static_cast<double>(first(low_))) / 2.0;

        default:
            std::abort(); // Balancing invariant violated.
        }
    }

    void MedianBag::rebalance()
    {
        switch (balance_factor()) {
        case -2:
            high_.insert(extract_first(low_));
            break;

        case +2:
            low_.insert(extract_first(high_));
            break;

        default:
            break; // Can't be made more balanced.
        }
    }

    inline long MedianBag::balance_factor() const noexcept
    {
        return high_.size() - low_.size();
    }

    void print_without_trailing_fractional_zeros(const double value)
    {
        const auto precision = (value == std::nearbyint(value) ? 0 : 1);
        std::cout << std::setprecision(precision) << value << '\n';
    }
}

int main()
{
    std::ios_base::sync_with_stdio(false);
    std::cout << std::fixed;

    auto bag = MedianBag{};

    auto count = int{};
    for (std::cin >> count; count > 0; --count) {
        auto opcode = std::string{};
        auto argument = int{};
        if (!(std::cin >> opcode >> argument)) abort();

        if (opcode == "a") {
            bag.insert(argument);
        } else if (opcode == "r") {
            if (!bag.erase(argument) || bag.empty()) {
                std::cout << "Wrong!\n";
                continue;
            }
        } else {
            std::abort(); // Unrecognized opcode.
        }

        print_without_trailing_fractional_zeros(bag.median());
    }
}
