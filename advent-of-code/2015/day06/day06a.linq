<Query Kind="Program">
  <Namespace>System.Globalization</Namespace>
</Query>

// Advent of code 2015, day 6, part A

internal static class Program {
    private const int GridSize = 1000;
    
    private static readonly Regex InstructionRegex =
        new Regex(@"^(?<action>turn (?:on|off)|toggle)"
                + @" (?<minRow>\d+),(?<minCol>\d+) through"
                + @" (?<maxRow>\d+),(?<maxCol>\d+)$");
    
    private enum Act : byte {
        TurnOn,
        TurnOff,
        Toggle
    }
    
    private readonly struct Instruction {
        internal Instruction(string line)
        {
            var match = InstructionRegex.Match(line);
            if (!match.Success) {
                throw new ArgumentException(paramName: nameof(line),
                                            message: "malformed line");
            }
            
            var groups = match.Groups;
            
            Act = groups["action"].Value switch {
                "turn on"  => Act.TurnOn,
                "turn off" => Act.TurnOff,
                "toggle"   => Act.Toggle,
                
                _ => throw new NotSupportedException(
                        "internal error (parsing)")
            };
            
            short GetBound(string name)
            {
                var bound = short.Parse(groups[name].Value);
                if (0 <= bound && bound < GridSize) return bound;
                throw new InvalidOperationException("bound is out of range");
            }
            
            MinRow = GetBound("minRow");
            MinCol = GetBound("minCol");
            MaxRow = GetBound("maxRow");
            MaxCol = GetBound("maxCol");
        }
        
        internal bool Affects(int row, int col)
            => (MinRow <= row && row <= MaxRow)
            && (MinCol <= col && col <= MaxCol);
        
        internal Act Act { get; }
        
        private short MinRow { get; }
        private short MinCol { get; }
        private short MaxRow { get; }
        private short MaxCol { get; }
    }
    
    private static IEnumerable<Act> ActsAffecting(
            this IEnumerable<Instruction> instructions, int row, int col)
        => from instruction in instructions
           where instruction.Affects(row, col)
           select instruction.Act;
    
    private static bool Run(this IEnumerable<Act> acts)
    {
        var state = false; // not initially illuminated
        
        foreach (var act in acts) {
            state = act switch {
                Act.TurnOn  => true,
                Act.TurnOff => false,
                Act.Toggle  => !state,
               
                _ => throw new NotSupportedException(
                        "internal error (running)")
            };
        }
        
        return state;
    }
    
    private static void Main()
    {
        var instructions =
            File.ReadLines("input")
                .Select(line => line.Trim())
                .Where(line => line.Length != 0)
                .Select(line => new Instruction(line))
                .ToList();
        
        var endStates =
            from row in Enumerable.Range(0, GridSize)
            from col in Enumerable.Range(0, GridSize)
            select instructions.ActsAffecting(row, col).Run();
        
        endStates.Count(state => state).Dump();
    }
}
