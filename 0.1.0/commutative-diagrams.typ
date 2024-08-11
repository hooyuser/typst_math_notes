#import "@preview/cetz:0.2.2"

#import "@preview/fletcher:0.5.1" as fletcher: diagram, node, edge


// define commutative diagram
#let commutative_diagram(math_content, ..args) = align(center)[
  #v(1em, weak: true)
  #diagram(label-size: 0.8em, math_content, ..args)#v(1em, weak: true)
]


#let reverse_arrow(arrow) = {
  let res = arrow
  if arrow.starts-with("<") {
    res = (">" + res.slice(1)).rev()
  }
  if arrow.ends-with(">") {
    res = (res.slice(0, -1) + "<").rev()
  }
  res
}

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
  g_arrow: "->",
  Fg_arrow: "->",
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
  edge(p_X, p_Y, g, g_arrow)
  let arrow_FX_FY = if contravariant {
    reverse_arrow(Fg_arrow)
  } else {
    Fg_arrow
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
  g_arrow: "->",
  Fg_arrow: "->",
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
    g_arrow: g_arrow,
    Fg_arrow: Fg_arrow,
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

#let square_cd_element(
  A11: ($$, $$),
  A12: ($$, $$),
  A21: ($$, $$),
  A22: ($$, $$),
  Ff: $$,
  Gf: $$,
  theta_l: ($$, $$),
  theta_r: ($$, $$),
  Ff_arrow: "->",
  Gf_arrow: "->",
  theta_l_arrow: ("->", "|->"),
  theta_r_arrow: ("->", "|->"),
) = commutative_diagram({

  let width = 1
  let height = 1

  let (p_A11, p_A12, p_A21, p_A22) = ((2 * width, 0), (3 * width, 0), (2 * width, height), (3 * width, height))
  let (p_a11, p_a12, p_a21, p_a22) = ((0, 0), (5 * width, 0), (0, height), (5 * width, height))
  let (p_in11, p_in12, p_in21, p_in22) = ((width, 0), (4 * width, 0), (width, height), (4 * width, height))

  node(p_A11, A11.at(0))
  node(p_A12, A12.at(0))
  node(p_A21, A21.at(0))
  node(p_A22, A22.at(0))
  edge(p_A11, p_A12, Ff, Ff_arrow)
  edge(p_A21, p_A22, Gf, Gf_arrow, right)
  edge(p_A11, p_A21, theta_l.at(0), theta_l_arrow.at(0), right)
  edge(p_A12, p_A22, theta_r.at(0), theta_r_arrow.at(0), left)

  if (A11.at(1) != $$ and A21.at(1) != $$) {
    node(p_a11, A11.at(1))
    node(p_a21, A21.at(1))
    node(p_in11, $in.rev$)
    node(p_in21, $in.rev$)
    edge(p_a11, p_a21, theta_l.at(1), theta_l_arrow.at(1))
  }

  if (A12.at(1) != $$ and A22.at(1) != $$) {
    node(p_a12, A12.at(1))
    node(p_a22, A22.at(1))
    node(p_in12, $in$)
    node(p_in22, $in$)
    edge(p_a12, p_a22, theta_r.at(1), theta_r_arrow.at(1), left)
  }

})


