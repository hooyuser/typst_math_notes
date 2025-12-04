#import "theme.typ": with_theme_config
#import "math-notes.typ": current-env-name


#let single_line_gradient(mid_color, edge_color, ratio, ..args) = {
  let interp_pos_1 = (100% - ratio) * 50%
  let interp_pos_2 = (100% + ratio) * 50%
  let stops = (
    (mid_color, 0%),
    (mid_color, interp_pos_1),
    (edge_color, interp_pos_1),
    (edge_color, interp_pos_2),
    (mid_color, interp_pos_2),
    (mid_color, 100%),
  )
  gradient.linear(..stops, ..args)
}

#let vertical_line_stroke = (
  paint: single_line_gradient(
    luma(100%, 0%),
    luma(0%, 30%),
    80%,
    angle: 90deg,
  ),
  thickness: 0.5pt,
)

#let vertical_line_stroke_white = (
  paint: single_line_gradient(
    luma(100%, 0%),
    white,
    80%,
    angle: 90deg,
  ),
  thickness: 0.5pt,
)

// See the strokes section for details on this!
#let frame = (x, y) => (
  bottom: if y >= 1 {
    0.5pt + rgb("#ABB0AE")
  },
  left: if x > 0 {
    if y == 0 {
      vertical_line_stroke_white
    } else {
      vertical_line_stroke
    }
  },
)

#let simple-table(columns: 2, ..items) = align(center)[
  #show table.cell.where(y: 0): it => {
    set text(white)
    strong(it)
  }
  #v(0.5em, weak: false)
  #with_theme_config(theme => context {
    let thm-env = current-env-name()
    let front-color = if thm-env == none {
      oklch(43.38%, 0.077, 71.65deg)
    } else if thm-env == "example" {
      theme.at("example_env_color_dict").at("header")
    } else {
      theme.at("thm_env_color_dict").at(thm-env).at("front").desaturate(20%)
    }
    table(
      columns: columns,
      stroke: frame,
      // fill: (_, y) => if y == 0 { rgb("#2a7f7f") },
      fill: (_, y) => if y == 0 { front-color },
      column-gutter: -0.5pt,
      row-gutter: 0pt,
      inset: 8pt,
      ..items.pos(),
      table.hline(stroke: 0.6pt + rgb("#264343")),
    )
  })
]
