// Symbols for limit and colimit
#let rightarrow = $stretch(->, size: #15pt)$

#let leftarrow = $stretch(<-, size: #15pt)$
#let movebase(size, x) = text(baseline: size)[#x]

#let (varprojlim, varinjlim) = (leftarrow, rightarrow).map(arrow => $display(limits(lim_(movebase(#(-1.9pt), arrow))))$)

#let injlim(subscript) = $varinjlim_movebase(#(-2.8pt), subscript)$
#let projlim(subscript) = $varprojlim_movebase(#(-2.8pt), subscript)$
