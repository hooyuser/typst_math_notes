#import "@preview/fletcher:0.5.1" as fletcher: diagram, node, edge


// define commutative diagram
#let commutative_diagram(math_content, ..args) = align(center)[
  #v(1em, weak: true)
  #diagram(label-size: 0.8em, math_content, ..args)#v(1em, weak: true)
]


#let functor_diagram_info(
  F: $$,
  C: $$,
  D: $$,
  g: $$,
  X: $$,
  Y: $$,
  Fg: $$,
  FX: $$,
  FY: $$,
  Fg_e: $$,
  FX_e: $$,
  FY_e: $$,
  contravariant: false,
) = {
  let width = 1.7
  let width_in = 2.3
  let width_e = 2.8
  let (y1, y2) = (0.5, 1.9)

  let (p_C, p_D) = ((0, 0), (width, 0))
  let (p_X, p_Y) = ((0, y1), (0, y2))
  let (p_FX, p_FY) = ((width, y1), (width, y2))

  node(p_C, C)
  node(p_D, D)
  node(p_X, X)
  node(p_FX, FX)
  node(p_Y, Y)
  node(p_FY, FY)
  edge(p_X, p_Y, g, "->")
  let arrow_FX_FY = if contravariant {
    "<-"
  } else {
    "->"
  }
  edge(p_FX, p_FY, Fg, arrow_FX_FY, left)

  if (FX_e != $$ or FY_e != $$) {
    let (p_FX_e, p_FY_e) = ((width_e, y1), (width_e, y2))
    node((width_in, y1), $in.rev$)
    node((width_in, y2), $in.rev$)
    node(p_FX_e, FX_e)
    node(p_FY_e, FY_e)
    let arrow_FX_FY_e = if contravariant {
      "<-|"
    } else {
      "|->"
    }
    edge(p_FX_e, p_FY_e, Fg_e, arrow_FX_FY_e, left)
  }

  let pad = 0.3
  let mid_y = (y1 + y2) / 2
  edge(
    (pad, mid_y),
    (width - pad, mid_y),
    F,
    "->",
    decorations: cetz.decorations.wave.with(amplitude: .06, segment-length: .2, start: 10%, stop: 90%),
  )
}


#let functor_diagram(
  F: $$,
  C: $$,
  D: $$,
  g: $$,
  X: $$,
  Y: $$,
  Fg: $$,
  FX: $$,
  FY: $$,
  Fg_e: $$,
  FX_e: $$,
  FY_e: $$,
  contravariant: false,
) = commutative_diagram(
  functor_diagram_info(
    F: F,
    C: C,
    D: D,
    g: g,
    X: X,
    Y: Y,
    Fg: Fg,
    FX: FX,
    FY: FY,
    Fg_e: Fg_e,
    FX_e: FX_e,
    FY_e: FY_e,
    contravariant: contravariant,
  ),
)

#let square_cd(
  A11: $$,
  A12: $$,
  A21: $$,
  A22: $$,
  Ff: $$,
  Gf: $$,
  theta_l: $$,
  theta_r: $$,
  Ff_arrow: "->",
  Gf_arrow: "->",
  theta_l_arrow: "->",
  theta_r_arrow: "->",
) = commutative_diagram({
  let width = 1
  let height = 1

  let (p_A11, p_A12, p_A21, p_A22) = ((0, 0), (width, 0), (0, height), (width, height))

  node(p_A11, A11)
  node(p_A12, A12)
  node(p_A21, A21)
  node(p_A22, A22)
  edge(p_A11, p_A12, Ff, Ff_arrow)
  edge(p_A21, p_A22, Gf, Gf_arrow, right)
  edge(p_A11, p_A21, theta_l, theta_l_arrow)
  edge(p_A12, p_A22, theta_r, theta_r_arrow, left)
})
