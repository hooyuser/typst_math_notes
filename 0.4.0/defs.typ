// Shorthand notations for common categories
#import "utils.typ": injlim, projlim

#let Cat = math.op($sans("Cat")$)
#let CAT = math.op($sans("CAT")$)
#let Cocone = math.op($sans("Cocone")$)

#let Set = math.op($sans("Set")$)
#let Top = math.op($sans("Top")$)
#let Grp = math.op($sans("Grp")$)
#let Grpd = math.op($sans("Grpd")$)
#let FinGrp = math.op($sans("FinGrp")$)
#let Ab = math.op($sans("Ab")$)
#let FinAb = math.op($sans("FinAb")$)
#let TopGrp = math.op($sans("TopGrp")$)
#let LCHGrp = math.op($sans("LCHGrp")$)
#let LCA = math.op($sans("LCA")$)  // locally compact Hausdorff abelian groups
#let CLieGrp = math.op($sans("CLieGrp")$)
#let Vect(k) = math.op($#k#h(0.1em)sans("-Vect")$)
#let FinVect(k) = math.op($#k#h(0.1em)sans("-FinVect")$)
#let Mod(k) = math.op($#k#h(0.1em)sans("-Mod")$)
#let Alg(k) = math.op($#k#h(0.1em)sans("-Alg")$)
#let CAlg(k) = math.op($#k#h(0.1em)sans("-CAlg")$)
#let CHilb = math.op($CC#h(0.07em)sans("-Hilb")$)  // Common Definitions of Morphisms in Hilb: Bounded Linear Maps / All Linear Maps / Short Linear Maps / Isometric Isomorphisms, Here We Use Bounded Linear Maps
#let Fld = math.op($sans("Fld")$)
#let Ring = math.op($sans("Ring")$)
#let CRing = math.op($sans("CRing")$)
#let TopRing = math.op($sans("TopRing")$)
#let Sh(C, X) = $op(sans("Sh")_(#C))(#(X))$
#let PSh(C, X) = $op(sans("Psh")_(#C))(#(X))$
#let lcSh(C, X) = $op(sans("Sh")_(#C)^(op("lc")))(#X)$  // locally constant sheaves
#let Sch = math.op($sans("Sch")$)  // schemes
#let TopMan = math.op($sans("TopMan")$)  // topological manifolds
#let Man = math.op($sans("Man")^(C^oo)$)  // smooth manifolds
#let Man(..args) = {
  let xs = args.pos()
  if xs.len() == 0 {
    math.op($sans("Man")^(C^oo)$) // smooth manifolds
  } else if xs.len() == 1 {
    let r = xs.at(0)
    math.op($sans("Man")^(C^(#r))$) // C^r differentiable manifolds
  } else {
    panic("Man expects at most one argument")
  }
}

#let CMan = math.op($sans("CMan")$)  // complex manifolds
#let SmVBun(K, ..args) = {
  let xs = args.pos()

  if xs.len() == 0 {
    math.op($sans("VBun")^(C^oo)_(#K)$) // smooth vector bundles
  } else if xs.len() == 1 {
    let X = xs.at(0)
    math.op($sans("VBun")^(C^oo)_(#K) (#X)$) // smooth vector bundles over a fixed base manifold X
  } else {
    panic("SmVBun expects at most one argument after K")
  }
}

#let LocFree(O) = math.op($sans("LocFree")_(#O)^(op("fin"))$)  // locally free sheaves of O-modules



// Groups
#let chargrp(G) = $frak(X)(#G)$  // character group of G, which consists of all group homomorphisms from G to ℂ^×
#let pontdual(G) = $#G^(or.curly)$ // Pontryagin dual of a locally compact abelian group, which consists of all continuous group homomorphisms from G to the circle group S^1
#let Gal = math.op("Gal")  // Galois group

// Linear Algebra Groups
#let SL = math.op("SL")
#let PSL = math.op("PSL")
#let GL = math.op("GL")

// Topological vector spaces
#let topdual(X) = $#X^(')$  // topological dual of a topological 𝕜-vector space X, which consists of all continuous linear functionals from X to 𝕜

// Fields
#let kk = $bb(k)$

// Other common notations
#let Ob = math.op("Ob")
#let Hom = math.op("Hom")
#let Tr = math.op("Tr")
#let Frob = math.op("Frob")
#let char = math.op("char")  // characteristic of a ring
#let Frac = math.op("Frac")
#let supp = math.op("supp")  // support
#let spec(x) = $op("Spec")(#x)$  // spectrum of a ring
#let sheafify(x) = $cal(#x)^(#h(0.2em)op("sh"))$  // sheafification of a presheaf
#let res(V, U) = $op("res")_(#V supset.eq #U)$  // restriction map from open set V to open set U
#let affine = $bold(upright(A))$  // affine space

#let acts = $arrow.cw.half$  // left action symbol
#let racts = $arrow.ccw.half$  // right action symbol

#let evaluated(x) = $lr(zwj#x|)$

// Custom matrix with [| ... |] delimiters
#let mmat(..array) = (
  $
    lr([| #math.mat(delim: none, ..array) |], size: #120%)
  $
)

// Set font for mathscr
// #let scr(it) = text(
//   font: "New Computer Modern Math",
//   $std.math.scr(it)$,
// )

// Congruence modulo n
#let pmod(n) = $med (mod med #n)$


// No indentation paragraph
#let noindent(body) = {
  set par(first-line-indent: 0pt)
  body
}

#let xleftarrow = $stretch(<-, size: #150%)$
#let xrightarrow = $stretch(->, size: #150%)$
#let mapsfrom = $arrow.l.bar.long$

#let (varinjlim, varprojlim) = {
  let factory = arrowsym => context {
    let size = measure[lim].width
    let arrow = pad(top: -1em, math.stretch(math.script(arrowsym), size: size))
    math.attach(math.limits[lim], b: arrow)
  }
  (sym.arrow.r, sym.arrow.l).map(factory).map(math.op.with(limits: true))
}
