# Kruskal: Really Special Subtree (MST)

All minimum spanning trees have the same total weight, so the tie-breaking
rules in the problem description can actually be ignored, since the problem is
only asking what the "really special" MST's total weight is.

In the Java solutions, `kruskalmstrsub.java` is compatible with Java 15 with
preview features turned off. `kruskalmstrsub_r.java` uses a record type for
`Edge`, so it requires at least Java 16, or preview features, and is therefore
not actually submittable (at the time of this writing) on HackerRank.
