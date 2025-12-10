#import "theme.typ": with_theme_config
#import "math-notes.typ": current-env-name

// Badge
#let rounded_badge(left, right, color: gray, background: gray) = {
  (
    box(
      stroke: color,
      radius: (left: 50pt), // Pill/capsule shape
      inset: (left: 5pt, y: 4pt), // Generous horizontal, moderate vertical padding
      baseline: 25%, // Center with surrounding text
      {
        set text(
          fill: color.darken(15%),
          size: 0.8em,
        )
        $left #h(4pt)$
      },
    )
      + box(
        stroke: color,
        fill: color,
        radius: (right: 50pt), // Pill/capsule shape
        inset: (right: 5pt, y: 4pt), // Generous horizontal, moderate vertical padding
        baseline: 25%, // Center with surrounding text
        {
          set text(
            fill: white,
            weight: "bold",
            size: 0.8em,
          )
          $#h(4pt)right$
        },
      )
  )
}

#let badge-triangle(height, color, x_end: 0.2em) = curve(
  fill: color,
  stroke: (paint: color),
  curve.line((0pt, height - 0.1pt)),
  curve.line((-x_end, height - 0.1pt)),
  curve.close(),
)

#let rounded_badge_slanted(left, right, color: gray, background_color: white) = context {
  let triangle-width = 0.2em
  let mid-pad = 0.3636em
  let left-text = text(
    fill: color.darken(15%),
    size: 0.8em,
    $left#h(triangle-width + mid-pad)$,
  )
  let right-text = text(
    fill: white,
    weight: "bold",
    size: 0.8em,
    $#h(mid-pad - 0.5 * triangle-width)right$,
  )
  let inset = 4pt
  let left-height = measure(left-text).height
  let right-height = measure(right-text).height
  let total-height = calc.max(left-height, right-height) + inset * 2
  box(
    inset: (top: 0em, bottom: -0.2em),
    // stroke: 0.5pt,
    stack(
      dir: ltr,
      box(
        stroke: (rest: color, right: none),
        radius: (left: 50pt), // Pill/capsule shape
        inset: (left: 5pt, y: 4pt), // Generous horizontal, moderate vertical padding
        baseline: 25%, // Center with surrounding text
        left-text,
      ),
      badge-triangle(total-height, color, x_end: triangle-width),
      box(
        stroke: color,
        fill: color,
        radius: (right: 50pt), // Pill/capsule shape
        inset: (right: 5pt, y: 4pt), // Generous horizontal, moderate vertical padding
        baseline: 25%, // Center with surrounding text
      )[
        #show math.equation: set text(fill: background_color)
        #right-text
      ],
    ),
  )
}

#let type_badge_internal(badge_func, ..args) = {
  let result = ()
  // Parse matrix-like arguments (semicolon creates rows, comma creates columns)
  let rows = args.pos()

  // If input is a single row
  if type(rows) == array and rows.len() > 0 and type(rows.at(0)) != array {
    return badge_func(rows.at(0), rows.at(1))
  }

  // Else, input is a 2D array

  let separator = h(0.3em)

  for (i, row) in rows.enumerate() {
    // Each row is an array of elements
    if type(row) == array and row.len() >= 2 {
      // Take first two elements as the pair
      result.push(badge_func(row.at(0), row.at(1)))
      if i < rows.len() - 1 {
        result.push(separator)
      }
    }
  }

  result.join()
}


#let typebadge(..args) = with_theme_config(theme => context {
  let thm-env = current-env-name()
  let front-color = if thm-env == "example" {
    theme.at("example_env_color_dict").at("frame").darken(2%).desaturate(-25%)
  } else {
    theme.at("thm_env_color_dict").at(thm-env).at("front").desaturate(20%)
  }
  let background-color = if thm-env == "example" {
    theme.at("example_env_color_dict").at("background").darken(5%)
  } else {
    theme.at("thm_env_color_dict").at(thm-env).at("background")
  }
  type_badge_internal(rounded_badge_slanted.with(color: front-color.lighten(20%).saturate(10%), background_color: background-color), ..args)
})
