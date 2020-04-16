<Query Kind="Statements" />

checked { // Doesn't affect Enumerable.Sum, but that's already checked.
    var ribbons =
        from line in File.ReadAllLines("input")
        select line.Trim() into line
        where line.Length != 0
        select Array.ConvertAll(line.Split('x'), int.Parse) into edges
        let minPerimeter = (edges.Sum() - edges.Max()) * 2
        let volume = edges.Aggregate((x, y) => x * y)
        select minPerimeter + volume;
    
    var totalRibbon = ribbons.Sum();
    totalRibbon.Dump();
}
