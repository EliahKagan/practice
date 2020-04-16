<Query Kind="Statements" />

static (int, int)? Interpret(char ch)
    => ch switch {
        '^' => (-1, 0),
        'v' => (+1, 0),
        '<' => (0, -1),
        '>' => (0, +1),
        _ => null
    };

var allMovesWithIndices =
    File.ReadAllText("input")
        .Select(Interpret)
        .OfType<(int, int)>()
        .Select((move, index) => (move, index));

var evenMoves = new List<(int, int)>();
var oddMoves = new List<(int, int)>();

foreach (var (move, index) in allMovesWithIndices)
    (index % 2 == 0 ? evenMoves : oddMoves).Add(move);

var vis = new HashSet<(int, int)>();

void TakeTrip(IEnumerable<(int, int)> moves, int i = 0, int j = 0)
{
    checked {
        vis.Add((i, j)); // Visit the initial location.
        
        foreach (var (di, dj) in moves)
            vis.Add((i += di, j += dj)); // Visit this new location.
    }
}


TakeTrip(evenMoves);
TakeTrip(oddMoves);

vis.Count.Dump();
