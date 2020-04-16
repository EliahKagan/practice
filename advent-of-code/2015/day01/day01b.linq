<Query Kind="Statements" />

static int FindNegativePosition(string input)
{
    var height = 0;
    var index = 0;
    
    foreach (var ch in input) {
        ++index;
        
        switch (ch) {
        case '(':
            ++height;
            break;
        
        case ')':
            if (--height < 0) return index;
            break;
        
        default:
            break; // Ignore other characters.
        }
    }
    
    throw new ArgumentException(paramName: nameof(input),
                                message: "negative height not reached");
}

FindNegativePosition(File.ReadAllText("input")).Dump();
