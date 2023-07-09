// LeetCode #200 - Number of Islands
// https://leetcode.com/problems/number-of-islands/
// By recursive depth-first search.

static void fill(char *restrict const *restrict const grid,
                 const int m, const int n, const int i, const int j)
{
    if (0 <= i && i < m && 0 <= j && j < n && grid[i][j] != '0') {
        grid[i][j] = '0';

        fill(grid, m, n, i, j - 1);
        fill(grid, m, n, i, j + 1);
        fill(grid, m, n, i - 1, j);
        fill(grid, m, n, i + 1, j);
    }
}

static int count_islands(char *restrict const *restrict const grid,
                         const int m, const int n)
{
    int count = 0;

    for (int i = 0; i < m; ++i) {
        for (int j = 0; j < n; ++j) {
            if (grid[i][j] != '0') {
                ++count;
                fill(grid, m, n, i, j);
            }
        }
    }

    return count;
}

int numIslands(char *restrict const *restrict const grid,
               const int gridSize,
               const int *restrict const gridColSize)
{
    return count_islands(grid, gridSize, gridColSize[0]);
}
