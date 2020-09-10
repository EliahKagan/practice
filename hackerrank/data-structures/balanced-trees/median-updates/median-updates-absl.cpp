// HackerRank - Median Updates
// https://www.hackerrank.com/challenges/median
// In C++14, since that's what HackerRank supports. The problem is intended
// to be solved with self-balancing trees, but this solution uses binary heaps
// equipped with an O(log(n)) remove operation.
//
// This differs from median-updates.cpp because, there, the hash-based
// containers facilitating removal are std::unordered_map and
// std::unordered_set, and here they are the "Swiss tables" absl::flat_hash_set
// and absl::flat_hash_map. The main difference relevant to performance is that
// the standard hash-based containers are usually implemented to resolve
// collisions with separate chaining, while the hash-based containers in Abseil
// resolve collisions with open addressing.

#include <cmath>
#include <cstdlib>
#include <functional>
#include <iomanip>
#include <iostream>
#include <iterator>
#include <limits>
#include <string>
#include <utility>
#include <vector>
#include <absl/container/flat_hash_map.h>
#include <absl/container/flat_hash_set.h>

namespace {
    // A priority queue with an O(log(n)) remove operation, implemented as a
    // binary heap augmented with a table mapping each key to all of its
    // occurrences in the heap. Code that uses this class template is
    // responsible for determining that Comparer is compatible with equality on
    // the element type T. This is maxheap with respect to the comparer.
    template<typename T, typename Compare>
    class BinaryHeap {
    public:
        explicit BinaryHeap(Compare compare = Compare{}) noexcept;
        bool empty() const noexcept;
        std::size_t size() const noexcept;
        void clear() noexcept;
        void push(T value) noexcept;
        T pop() noexcept;
        T top() const noexcept;
        bool erase(T value) noexcept;

    private:
        static constexpr auto npos = std::numeric_limits<std::size_t>::max();

        void cut_root() noexcept;
        std::size_t highest_equal_ancestor(std::size_t child) const noexcept;
        void yank_up(std::size_t child) noexcept;
        std::size_t sift_up(T child_value) noexcept;
        std::size_t sift_down(T parent_value) noexcept;
        std::size_t pick_child(std::size_t parent) const noexcept;
        constexpr bool order_ok(T parent_value, T child_value) const noexcept;

        absl::flat_hash_map<T, absl::flat_hash_set<std::size_t>> map_ {};
        std::vector<T> heap_ {};
        Compare compare_;
    };

    template<typename T, typename Compare>
    BinaryHeap<T, Compare>::BinaryHeap(Compare compare) noexcept
        : compare_{compare}
    {
    }

    template<typename T, typename Compare>
    inline bool BinaryHeap<T, Compare>::empty() const noexcept
    {
        return heap_.empty();
    }

    template<typename T, typename Compare>
    inline std::size_t BinaryHeap<T, Compare>::size() const noexcept
    {
        return heap_.size();
    }

    template<typename T, typename Compare>
    void BinaryHeap<T, Compare>::clear() noexcept
    {
        map_.clear();
        heap_.clear();
    }

    template<typename T, typename Compare>
    void BinaryHeap<T, Compare>::push(T value) noexcept
    {
        heap_.emplace_back();
        const auto child = sift_up(value);
        map_[value].insert(child);
        heap_[child] = std::move(value);
    }

    template<typename T, typename Compare>
    T BinaryHeap<T, Compare>::pop() noexcept
    {
        auto value = top();

        if (size() == 1) {
            clear();
        } else {
            const auto pos = map_.find(value);
            auto& indices = pos->second;

            if (indices.size() == 1)
                map_.erase(pos);
            else
                indices.erase(0);

            cut_root();
        }

        return value;
    }

    template<typename T, typename Compare>
    T BinaryHeap<T, Compare>::top() const noexcept
    {
        return heap_.front();
    }

    template<typename T, typename Compare>
    bool BinaryHeap<T, Compare>::erase(T value) noexcept
    {
        const auto pos = map_.find(value);
        if (pos == std::end(map_)) return false;

        if (size() == 1) {
            clear();
        } else {
            auto& indices = pos->second;

            // Get any index to this value in the heap.
            auto child = *std::cbegin(indices);

            if (indices.size() == 1) {
                map_.erase(pos);
            } else {
                child = highest_equal_ancestor(child);
                indices.erase(child);
            }

            yank_up(child);
            cut_root();
        }

        return true;
    }

    template<typename T, typename Compare>
    void BinaryHeap<T, Compare>::cut_root() noexcept
    {
        auto value = heap_.back();
        heap_.pop_back();

        auto& indices = map_.at(value);
        indices.erase(size());

        const auto index = sift_down(value);
        indices.insert(index);
        heap_[index] = std::move(value);
    }

    template<typename T, typename Compare>
    std::size_t BinaryHeap<T, Compare>::highest_equal_ancestor(
            std::size_t child) const noexcept
    {
        const auto value = heap_[child];

        while (child != 0) {
            const auto parent = (child - 1) / 2;
            if (heap_[parent] != value) break;
            child = parent;
        }

        return child;
    }

    template<typename T, typename Compare>
    void BinaryHeap<T, Compare>::yank_up(std::size_t child) noexcept
    {
        while (child != 0) {
            const auto parent = (child - 1) / 2;
            auto parent_value = heap_[parent];

            auto& indices = map_.at(parent_value);
            indices.erase(parent);
            indices.insert(child);
            heap_[child] = std::move(parent_value);

            child = parent;
        }
    }

    template<typename T, typename Compare>
    std::size_t BinaryHeap<T, Compare>::sift_up(T child_value) noexcept
    {
        auto child = size() - 1;

        while (child != 0) {
            const auto parent = (child - 1) / 2;
            auto parent_value = heap_[parent];
            if (order_ok(parent_value, child_value)) break;

            auto& indices = map_.at(parent_value);
            indices.erase(parent);
            indices.insert(child);
            heap_[child] = std::move(parent_value);

            child = parent;
        }

        return child;
    }

    template<typename T, typename Compare>
    std::size_t BinaryHeap<T, Compare>::sift_down(T parent_value) noexcept
    {
        auto parent = std::size_t{0};

        for (; ; ) {
            const auto child = pick_child(parent);
            if (child == npos) break;
            auto child_value = heap_[child];
            if (order_ok(parent_value, child_value)) break;

            auto& indices = map_.at(child_value);
            indices.erase(child);
            indices.insert(parent);
            heap_[parent] = std::move(child_value);

            parent = child;
        }

        return parent;
    }

    template<typename T, typename Compare>
    std::size_t
    BinaryHeap<T, Compare>::pick_child(const std::size_t parent) const noexcept
    {
        const auto left = parent * 2 + 1;
        if (left >= size()) return npos;

        const auto right = left + 1;
        return right == size() || order_ok(heap_[left], heap_[right])
                ? left
                : right;
    }

    template <typename T, typename Compare>
    constexpr bool BinaryHeap<T, Compare>::order_ok(
            const T parent_value, const T child_value) const noexcept
    {
        // This is maxheap relative to compare_, so what would violate this
        // invariant is for parent_value to be strictly less than child_value
        // (where compare_ is read as "is strictly less than").
        return !compare_(parent_value, child_value);
    }

    template<typename T>
    using MaxHeap = BinaryHeap<T, std::less<>>;

    template<typename T>
    using MinHeap = BinaryHeap<T, std::greater<>>;

    // A multiset with O(log(n)) insertion and deletion and O(1) median
    // finding.
    class MedianBag {
    public:
        bool empty() const noexcept;
        void insert(int value) noexcept;
        bool erase(int value) noexcept;
        double median() const noexcept;

    private:
        void rebalance() noexcept;
        std::size_t balance_factor() const noexcept;

        MaxHeap<int> low_ {};
        MinHeap<int> high_ {};
    };

    inline bool MedianBag::empty() const noexcept
    {
        return low_.empty() && high_.empty();
    }

    void MedianBag::insert(const int value) noexcept
    {
        if (!low_.empty() && value < low_.top())
            low_.push(value);
        else
            high_.push(value);

        rebalance();
    }

    bool MedianBag::erase(const int value) noexcept
    {
        if (low_.erase(value) || high_.erase(value)) {
            rebalance();
            return true;
        }

        return false;
    }

    double MedianBag::median() const noexcept
    {
        switch (balance_factor()) {
        case static_cast<std::size_t>(-1):
            return low_.top();

        case static_cast<std::size_t>(+1):
            return high_.top();

        case static_cast<std::size_t>(0):
            return (static_cast<double>(low_.top())
                    + static_cast<double>(high_.top())) / 2.0;

        default:
            std::abort(); // Balancing invariant violated.
        }
    }

    void MedianBag::rebalance() noexcept
    {
        switch (balance_factor()) {
        case static_cast<std::size_t>(-2):
            high_.push(low_.pop());
            break;

        case static_cast<std::size_t>(+2):
            low_.push(high_.pop());
            break;

        default:
            break;
        }
    }

    inline std::size_t MedianBag::balance_factor() const noexcept
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
