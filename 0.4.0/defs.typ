// Shorthand notations for common categories
#import "utils.typ": injlim, projlim

#let Set = math.op($sans("Set")$)
#let Top = math.op($sans("Top")$)
#let Grp = math.op($sans("Grp")$)
#let FinGrp = math.op($sans("FinGrp")$)
#let Ab = math.op($sans("Ab")$)
#let FinAb = math.op($sans("FinAb")$)
#let TopGrp = math.op($sans("TopGrp")$)
#let LCHGrp = math.op($sans("LCHGrp")$)
#let LCA = math.op($sans("LCA")$)  // locally compact Hausdorff abelian groups
#let Vect(k) = math.op($#k#h(0.1em)sans("-Vect")$)
#let FinVect(k) = math.op($#k#h(0.1em)sans("-FinVect")$)
#let Mod(k) = math.op($#k#h(0.1em)sans("-Mod")$)
#let CHilb = math.op($CC#h(0.07em)sans("-Hilb")$)  // Common Definitions of Morphisms in Hilb: Bounded Linear Maps / All Linear Maps / Short Linear Maps / Isometric Isomorphisms, Here We Use Bounded Linear Maps
#let Fld = math.op($sans("Fld")$)
#let Ring = math.op($sans("Ring")$)
#let CRing = math.op($sans("CRing")$)
#let TopRing = math.op($sans("TopRing")$)
#let Sh(C, X) = $op(sans("Sh")_(#C))(#(X))$
#let PSh(C, X) = $op(sans("PSh")_(#C))(#(X))$

// Common Linear Algebra Groups
#let SL = math.op("SL")
#let PSL = math.op("PSL")
#let GL = math.op("GL")

#let Tr = math.op("Tr")
#let Gal = math.op("Gal")
#let Frob = math.op("Frob")

#let racts = $arrow.ccw.half$  // right action symbol

// Custom matrix with [| ... |] delimiters
#let mmat(..array) = (
  $
    lr([| #math.mat(delim: none, ..array) |], size: #120%)
  $
)

// Set font for mathscr
#let scr(it) = text(
  font: "New Computer Modern Math",
  $std.math.scr(it)$,
)

// Congruence modulo n
#let pmod(n) = $med (mod med #n)$

// Groups
#let chargrp(G) = $frak(X)(#G)$  // character group of G, which consists of all group homomorphisms from G to ℂ^×
#let pontdual(G) = $#G^(or.curly)$ // Pontryagin dual of a locally compact abelian group, which consists of all continuous group homomorphisms from G to the circle group S^1

// No indentation paragraph
#let noindent(body) = {
  set par(first-line-indent: 0pt)
  body
}

// #let xrightarrow = $stretch(->, size: #150%)$
