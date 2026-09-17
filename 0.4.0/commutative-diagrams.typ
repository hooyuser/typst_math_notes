#import "@preview/cetz:0.3.4"
#import "@preview/fletcher:0.5.8": diagram, edge, node
#import "theme.typ": with_theme_config
#import "math-notes.typ": current-env-name

// define commutative diagram
#let commutative_diagram(math_content, ..args) = align(center)[
  #v(0.5em)
  #with_theme_config(theme_config => {
    let stroke_color = theme_config.at("text_color")

    let env = current-env-name()

    let background = if env == none {
      theme_config.at("background")
    } else if env == "example" {
      theme_config.at("example_env_color_dict").at("background")
    } else {
      theme_config.at("thm_env_color_dict").at(env).at("background")
    }

    diagram(
      label-size: 0.8em,
      label-sep: 0.1em,
      crossing-fill: background,
      math_content,
      ..args,
      edge-stroke: stroke_color,
    )
    v(0.5em)
  })
]

#let reverse_arrow(arrow) = {
  if arrow == "->" {
    "<-"
  } else if arrow == "<-" {
    "->"
  } else if arrow == "|->" {
    "<-|"
  } else if arrow == "<-|" {
    "|->"
  } else if arrow == "->>" {
    "<<-"
  } else if arrow == "<<-" {
    "->>"
  } else {
    arrow
  }
}

#let morphism_arrow(arrow, contravariant) = {
  if contravariant {
    reverse_arrow(arrow)
  } else {
    arrow
  }
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
  XY_base: $$,
  X_base_label: $$,
  Y_base_label: $$,

  g_arrow: "->",
  Fg_arrow: "->",
  Fg_e_arrow: "|->",

  contravariant: false,

  // ============================================================
  // Horizontal layout
  //
  // column 0 : X, Y
  // column 1 : FX, FY
  // column 2 : invisible horizontal spacer
  // column 3 : FX_e, FY_e
  //
  // ∋ does NOT occupy an elastic-grid column.
  // ============================================================
  width_spacer: 1,
  width: 2,
  width_e: 3,

  // Extra horizontal space between
  // FX/FY and FX_e/FY_e.
  horizontal_gap: 4em,

  // Position of ∋ inside the corridor between
  // FX/FY and the element column.
  //
  // 50% = centered.
  membership_pos: 50%,

  // ============================================================
  // Vertical layout
  //
  // row 0 : C, D
  // row 1 : X, FX, ∋, FX_e
  // row 2 : invisible vertical spacer
  // row 3 : Y, FY, ∋, FY_e
  // ============================================================

  node_y: (1, 3),

  // Extra vertical size of the dedicated spacer row.
  object_row_gap: 3em,

  // Padding used only by the wavy functor arrow.
  wave_pad: 0.18,
) = {
  let (y1, y2) = node_y
  let mid_y = (y1 + y2) / 2

  // ============================================================
  // Coordinates
  // ============================================================

  let p_C = (0, 0)
  let p_D = (width, 0)

  let p_X = (0, y1)
  let p_Y = (0, y2)

  let p_FX = (width, y1)
  let p_FY = (width, y2)

  let p_FX_e = (width_e, y1)
  let p_FY_e = (width_e, y2)

  // ============================================================
  // Categories
  // ============================================================

  node(
    p_C,
    C,
    name: <functor-C>,
  )

  node(
    p_D,
    D,
    name: <functor-D>,
  )

  // ============================================================
  // X, Y
  //
  // Keep Fletcher's default node geometry.
  // ============================================================

  node(
    p_X,
    X,
    name: <functor-X>,
  )

  node(
    p_Y,
    Y,
    name: <functor-Y>,
  )

  // ============================================================
  // FX, FY
  //
  // Also keep Fletcher's default node geometry.
  //
  // Therefore the vertical Fg arrow has the same normal
  // endpoint behaviour as g : X -> Y.
  // ============================================================

  node(
    p_FX,
    FX,
    name: <functor-FX>,
  )

  node(
    p_FY,
    FY,
    name: <functor-FY>,
  )

  // ============================================================
  // Invisible HORIZONTAL spacer column
  //
  // IMPORTANT:
  //
  // Do NOT use
  //
  //   height: 0pt
  //
  // together with an explicit width.
  //
  // Fletcher 0.5.8 computes width / height when both dimensions
  // are explicit, causing division by zero.
  //
  // Leaving height as `auto` makes Fletcher use its safe
  // automatic-measurement branch.
  // ============================================================

  node(
    (width_spacer, y1),
    width: horizontal_gap,
    height: auto,
    inset: 0pt,
    outset: 0pt,
    stroke: none,
    fill: none,
    snap: false,
  )

  // ============================================================
  // Invisible VERTICAL spacer row
  //
  // Symmetrically, width is left as `auto`.
  //
  // This row controls the distance between
  // the first and second object rows independently.
  // ============================================================

  node(
    (0, mid_y),
    width: auto,
    height: object_row_gap,
    inset: 0pt,
    outset: 0pt,
    stroke: none,
    fill: none,
    snap: false,
  )

  // ============================================================
  // Optional common base
  // ============================================================

  if (XY_base != $$) {
    let p_XY_base = (-1, mid_y)

    node(
      p_XY_base,
      XY_base,
    )

    edge(
      p_XY_base,
      p_X,
      X_base_label,
      "->",
      left,
    )

    edge(
      p_XY_base,
      p_Y,
      Y_base_label,
      "->",
      right,
    )
  }

  // ============================================================
  // g : X -> Y
  // ============================================================

  edge(
    p_X,
    p_Y,
    g,
    g_arrow,
    right,
  )

  // ============================================================
  // F(g) : FX -> FY
  // ============================================================

  edge(
    p_FX,
    p_FY,
    Fg,
    morphism_arrow(
      Fg_arrow,
      contravariant,
    ),
    left,
  )

  // ============================================================
  // Element layer
  // ============================================================

  if (FX_e != $$ or FY_e != $$) {
    // ----------------------------------------------------------
    // Actual element nodes.
    //
    // Keep default geometry so Fg_e also gets Fletcher's
    // normal endpoint spacing.
    // ----------------------------------------------------------

    node(
      p_FX_e,
      FX_e,
      name: <functor-FX-e>,
    )

    node(
      p_FY_e,
      FY_e,
      name: <functor-FY-e>,
    )

    // ----------------------------------------------------------
    // Physical bounding box of the whole FX/FY column.
    // ----------------------------------------------------------

    node(
      enclose: (
        <functor-FX>,
        <functor-FY>,
      ),
      name: <functor-F-column>,
      shape: "rect",
      inset: 0pt,
      outset: 0pt,
      stroke: none,
      fill: none,
      snap: false,
    )

    // ----------------------------------------------------------
    // Physical bounding box of the whole element column.
    // ----------------------------------------------------------

    node(
      enclose: (
        <functor-FX-e>,
        <functor-FY-e>,
      ),
      name: <functor-element-column>,
      shape: "rect",
      inset: 0pt,
      outset: 0pt,
      stroke: none,
      fill: none,
      snap: false,
    )

    // ----------------------------------------------------------
    // Shared physical x-coordinate for BOTH ∋ symbols.
    //
    // horizontal_gap has already enlarged the corridor.
    // membership_pos determines where inside that corridor
    // the ∋ symbols sit.
    // ----------------------------------------------------------

    let p_in_x = (
      <functor-F-column.east>,
      membership_pos,
      <functor-element-column.west>,
    )

    // Upper ∋
    node(
      (
        p_in_x,
        "|-",
        <functor-FX>,
      ),
      $in.rev$,
      inset: 0pt,
      outset: 0pt,
      snap: false,
    )

    // Lower ∋
    node(
      (
        p_in_x,
        "|-",
        <functor-FY>,
      ),
      $in.rev$,
      inset: 0pt,
      outset: 0pt,
      snap: false,
    )

    // ----------------------------------------------------------
    // Element morphism
    // ----------------------------------------------------------

    edge(
      p_FX_e,
      p_FY_e,
      Fg_e,
      morphism_arrow(
        Fg_e_arrow,
        contravariant,
      ),
      left,
    )
  }

  // ============================================================
  // Wavy functor arrow
  // ============================================================

  edge(
    (wave_pad, mid_y),
    (width - wave_pad, mid_y),
    F,
    "->",
    decorations: cetz.decorations.wave.with(
      amplitude: .06,
      segment-length: .2,
      start: 10%,
      stop: 90%,
    ),
  )
}

#let functor_diagram_info2(
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
  XY_base: $$,
  X_base_label: $$,
  Y_base_label: $$,
  g_arrow: "->",
  Fg_arrow: "->",
  Fg_e_arrow: "|->",
  contravariant: false,
  width: 1.7,
  width_in: 2.3,
  width_e: 2.8,
  node_y: (0.5, 1.9),
) = {
  let (y1, y2) = node_y
  let (p_C, p_D) = ((0, 0), (width, 0))
  let (p_X, p_Y) = ((0, y1), (0, y2))
  let (p_FX, p_FY) = ((width, y1), (width, y2))

  node(p_C, C)
  node(p_D, D)
  node(p_X, X)
  node(p_FX, FX)
  node(p_Y, Y)
  node(p_FY, FY)

  if (XY_base != $$) {
    let p_XY_base = (-width / 2, (y1 + y2) / 2)
    node(p_XY_base, XY_base)
    edge(p_XY_base, p_X, X_base_label, "->", left)
    edge(p_XY_base, p_Y, Y_base_label, "->", right)
  }

  edge(
    p_X,
    p_Y,
    g,
    g_arrow,
    right,
  )

  edge(
    p_FX,
    p_FY,
    Fg,
    morphism_arrow(Fg_arrow, contravariant),
    left,
  )

  if (FX_e != $$ or FY_e != $$) {
    let (p_FX_e, p_FY_e) = ((width_e, y1), (width_e, y2))

    node((width_in, y1), $in.rev$)
    node((width_in, y2), $in.rev$)
    node(p_FX_e, FX_e)
    node(p_FY_e, FY_e)

    edge(
      p_FX_e,
      p_FY_e,
      Fg_e,
      morphism_arrow(Fg_e_arrow, contravariant),
      left,
    )
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
  XY_base: $$,
  X_base_label: $$,
  Y_base_label: $$,
  contravariant: false,
  g_arrow: "->",
  Fg_arrow: "->",
  Fg_e_arrow: "|->",
  ..args,
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
    XY_base: XY_base,
    X_base_label: X_base_label,
    Y_base_label: Y_base_label,
    contravariant: contravariant,
    g_arrow: g_arrow,
    Fg_arrow: Fg_arrow,
    Fg_e_arrow: Fg_e_arrow,
  ),
  spacing: (0.5em, 1em),
  ..args,
)

#let square_cd_info(
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
  left_top: (0, 0),
  right_bottom: (1, 1),
) = {
  // ---------------------> x
  // |
  // |
  // v
  // y

  let (x_min, y_min) = left_top
  let (x_max, y_max) = right_bottom
  let (p_A11, p_A12, p_A21, p_A22) = ((x_min, y_min), (x_max, y_min), (x_min, y_max), (x_max, y_max))

  node(p_A11, A11)
  node(p_A12, A12)
  node(p_A21, A21)
  node(p_A22, A22)
  edge(p_A11, p_A12, Ff, Ff_arrow, left)
  edge(p_A21, p_A22, Gf, Gf_arrow, right)
  edge(p_A11, p_A21, theta_l, theta_l_arrow, right)
  edge(p_A12, p_A22, theta_r, theta_r_arrow, left)
}

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
  ..args,
) = commutative_diagram(
  square_cd_info(
    A11: A11,
    A12: A12,
    A21: A21,
    A22: A22,
    Ff: Ff,
    Gf: Gf,
    theta_l: theta_l,
    theta_r: theta_r,
    Ff_arrow: Ff_arrow,
    Gf_arrow: Gf_arrow,
    theta_l_arrow: theta_l_arrow,
    theta_r_arrow: theta_r_arrow,
  ),
  ..args,
)

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
  let (p_a11, p_a12, p_a21, p_a22) = ((0, 0), (4.6 * width, 0), (0, height), (4.6 * width, height))
  let (p_in11, p_in12, p_in21, p_in22) = ((width, 0), (3.8 * width, 0), (width, height), (3.8 * width, height))

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
    node(p_in11, $in$)
    node(p_in21, $in$)
    edge(p_a11, p_a21, theta_l.at(1), theta_l_arrow.at(1))
  }

  if (A12.at(1) != $$ and A22.at(1) != $$) {
    node(p_a12, A12.at(1))
    node(p_a22, A22.at(1))
    node(p_in12, $in.rev$)
    node(p_in22, $in.rev$)
    edge(p_a12, p_a22, theta_r.at(1), theta_r_arrow.at(1), left)
  }
})


#let functor_diagram_square_cd(
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
  g_arrow: "=>",
  Fg_arrow: "=>",
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
  let (y1, y2) = (0.5, 1.9)

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
    g_arrow: g_arrow,
    Fg_arrow: Fg_arrow,
    node_y: (y1, y2),
  )

  let cd_start_x = 2.8
  let cd_width = 2

  square_cd_info(
    A11: A11,
    A12: A12,
    A21: A21,
    A22: A22,
    Ff: Ff,
    Gf: Gf,
    theta_l: theta_l,
    theta_r: theta_r,
    Ff_arrow: Ff_arrow,
    Gf_arrow: Gf_arrow,
    theta_l_arrow: theta_l_arrow,
    theta_r_arrow: theta_r_arrow,
    left_top: (cd_start_x, y1),
    right_bottom: (cd_start_x + cd_width, y2),
  )
})

#let adjunction_pair(
  C: $$,
  D: $$,
  L: $$,
  R: $$,
) = commutative_diagram({
  let (p_C, p_D, p_adj) = ((0, 0), (1, 0), (0.5, 0))
  node(p_C, C)
  node(p_D, D)
  node(p_adj, $bot$)
  edge(p_C, p_D, L, "->", bend: +35deg)
  edge(p_C, p_D, R, "<-", bend: -35deg)
})

#let cetz_canvas(..args) = {
  set align(center)
  v(1em)
  with_theme_config(theme_config => {
    cetz.canvas(
      length: 1.2cm,
      background: theme_config.at("background"),
      ..args,
    )
  })
}


#let two_cell_diagram(
  C: $$,
  D: $$,
  upper: $$,
  lower: $$,
  two-arrow: $$,
  arrow-info: $$,

  upper-arrow: "->",
  lower-arrow: "->",
  two-arrow-type: "=>",

  bend: 35deg,
  two-arrow-x: 0.5,
  two-arrow-half-height: 0.18,

  spacing: 5em,
  ..args,
) = commutative_diagram(
  spacing: spacing,
  ..args,
  {
    let (p-C, p-D) = ((0, 0), (1, 0))

    node(p-C, C)
    node(p-D, D)

    edge(
      p-C,
      p-D,
      math.script(upper),
      upper-arrow,
      bend: +bend,
      label-side: left,
    )

    edge(
      p-C,
      p-D,
      math.script(lower),
      lower-arrow,
      bend: -bend,
      label-side: right,
    )

    edge(
      (two-arrow-x, -two-arrow-half-height),
      (two-arrow-x, +two-arrow-half-height),
      math.script(two-arrow),
      left,
      two-arrow-type,
    )

    if arrow-info != $$ {
      edge(
        (two-arrow-x, -two-arrow-half-height),
        (two-arrow-x, +two-arrow-half-height),
        math.script(arrow-info),
        right,
        " ",
      )
    }
  },
)



