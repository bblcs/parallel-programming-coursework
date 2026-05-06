== 7.1.1
Prove that for two arbitrary intervals `X` and `Y` at least one of the following cases holds:
- `X` and `Y` are disjoint and `X -> Y`; or
- `X` and `Y` are disjoint and `Y -> X`; or
- `X` and `Y` are overlapping intervals

$triangle.stroked.r$


Let `X` = (`x1`, `x2`), `Y` = (`y1`, `y2`), `x1` -> `x2`, `y1` -> `y2`. Then we have 6 possible cases. Lets brute-force:
- `x1 -> x2 -> y1 -> y2`: disjoint, `X` -> `Y`
- `x1 -> y1 -> x2 -> y2`: overlap
- `x1 -> y1 -> y2 -> x2`: overlap
- `y1 -> x1 -> x2 -> y2`: overlap
- `y1 -> x1 -> y2 -> x2`: overlap
- `y1 -> y2 -> x1 -> x2`: disjoint, `Y` -> `X`

$triangle.stroked.l$

== 7.1.2
Prove that `->` (precedence) binary relation on intervals is a partial order that:
- Irreflexive. Never true that `X -> X`.
- Antisymmetric. If `X -> Y` then not true `Y -> X`.
- Transitive. If `X -> Y` and `Y -> Z` then `X -> Z`.

Please also prove that precedence is indeed a partial order: provide an example with `X != Y` where `X -> Y` false and `Y -> X` is also false.


$triangle.stroked.r$

Let `X` = (`x1`, `x2`), `Y` = (`y1`, `y2`), `x1` -> `x2`, `y1` -> `y2`.
- Irreflexive because any interval overlaps itself.
- Antisymmetricity follows from the assymetricity of the primordial order.
- Transitivity follows from transitivity of the primordial order.
- Partial because never true for overlapping intervals.

$triangle.stroked.l$
