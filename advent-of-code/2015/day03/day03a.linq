<Query Kind="Statements" />

var vis = new HashSet<(int, int)>();

checked {
    var i = 0;
    var j = 0;
    vis.Add((i, j)); // Visit the initial location.

    foreach (var ch in File.ReadAllText("input")) {
        switch (ch) {
        case '^':
            --i;
            break;
        
        case 'v':
            ++i;
            break;
        
        case '<':
            --j;
            break;
        
        case '>':
            ++j;
            break;
        
        default:
            continue; // Drop other characters.
        }
        
        vis.Add((i, j)); // Visit this new location.
    }
}

vis.Count.Dump();
