#let section_style_1(it) = {
  block[
    #set par(first-line-indent: 0pt)
    #set text(size: 18pt)
    #v(0.5em)
    #h(-0.1em)
    #text(
      weight: 700,
      font: "STIX Two Text",
      fill: oklch(35%, 0, 0deg),
      counter(heading).display(it.numbering),
    )
    #h(0.5em)
    #text(
      weight: 700,
      font: "Baskervville",
      tracking: 0.1pt,
      fill: oklch(35%, 0, 0deg),
      it.body,
    )
    #v(0.4em)
  ]
}

#let section_style_2(it) = {
  block[
    #set par(first-line-indent: 0pt)
    #set text(size: 18pt)
    #v(0.5em)
    #rect(
      width: 100%,
      height: 1.5pt,
      fill: oklch(68.69%, 0.078, 165.61deg),
      stroke: none,
      radius: 0.03em,
      outset: (x: 2em),
    )
    #v(-0.4em)
    #let square_width = 0.6em
    #let square_padding = 0.9em
    #let square_color = oklch(68.69%, 0.078, 165.61deg)
    #place(
      dx: -square_width - square_padding,
      dy: 0.04em,
      grid(
        columns: (auto, auto),
        align: horizon,
        gutter: 0.1em,
        box(
          width: 0.15em,
          height: 0.75em,
          stroke: (rest: 0.05em + square_color, right: none),
          outset: (right: -0.04em),
        ),

        box(
          width: square_width,
          height: square_width,
          fill: square_color,
          radius: 0.02em,
        ),
      ),
    )
    #text(
      weight: 700,
      font: "STIX Two Text",
      fill: oklch(56.17%, 0.124, 157.21deg),
      counter(heading).display(it.numbering),
    )
    #h(0.5em)
    #text(
      weight: 700,
      font: "Baskervville",
      tracking: 0.1pt,
      fill: oklch(35%, 0, 0deg),
      it.body,
    )
    #v(-0.7em)
    #rect(
      width: 100%,
      height: 1.5pt,
      fill: oklch(68.69%, 0.078, 165.61deg),
      stroke: none,
      radius: 0.03em,
      outset: (x: 2em),
    )
    #v(0.4em)
  ]
}




// -----------------------------------------------------------------
// Heading Style
// -----------------------------------------------------------------
#let heading_style(it, chapter_color: luma(0%)) = {
  set block(above: 1.4em, below: 1em)

  if it.numbering == none {
    let body = it.body
    if body.has("children") {
      for ele in body.children {
        if ele.func() == metadata {
          if ele.value == "index" {
            return text(weight: 700, 28pt, font: "Lato", ligatures: false)[
              #it.body #v(2em, weak: true)
            ]
          }
        }
      }
    }
    text(weight: 700, 28pt, font: "Lato", ligatures: false)[
      #it.body #v(1em, weak: true)
    ]
  } else if it.level == 1 {
    block({
      set par(first-line-indent: 0em)
      text(weight: 700, 22pt, tracking: 0.5pt, font: "Lato", fill: chapter_color)[
        #v(2em)
        Chapter #counter(heading).display(it.numbering)#v(1.1em, weak: true)
      ]
      text(weight: 700, 28pt, font: "Lato", ligatures: false)[
        #it.body
      ]
      v(2em)
    })
  } else if it.level == 2 {
    section_style_1(it)
  } else if it.level == 3 {
    block({
      set par(first-line-indent: 0em)
      set text(13pt, weight: 700, font: "Satoshi", fill: oklch(35%, 0, 0deg))
      counter(heading).display(it.numbering)
      h(0.8em)
      it.body
    })
  } else {
    set text(weight: 700, font: "New Computer Modern")
    it
  }
}
