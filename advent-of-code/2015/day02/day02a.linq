<Query Kind="Statements" />

checked { // Doesn't affect Enumerable.Sum, but that's already checked.
    var packageAreas =
        from line in File.ReadAllLines("input")
        select line.Trim() into line
        where line.Length != 0
        select Array.ConvertAll(line.Split('x'), int.Parse) into edges
        select new[] {
            edges[0] * edges[1],
            edges[0] * edges[2],
            edges[1] * edges[2]
        } into sides
        let surfaceArea = sides.Sum() * 2
        let extra = sides.Min()
        select surfaceArea + extra;
    
    var totalArea = packageAreas.Sum();
    totalArea.Dump();
}