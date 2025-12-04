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

#let section_style_2(it, color: oklch(68.69%, 0.078, 165.61deg)) = {
  block[
    #set par(first-line-indent: 0pt, spacing: 0em)
    #set text(size: 18pt)
    #v(0.5em)
    #let line_width = 0.75pt
    #rect(
      width: 100%,
      height: line_width,
      fill: color,
      stroke: none,
      radius: 0.03em,
      outset: (x: 2em),
    )
    #v(-0.7em)
    #block[
      #set align(horizon)
      #let square_width = 0.55em
      #let square_padding = 0.95em
      #let square_color = color
      #let bracket_height = 0.83em
      #let bracket_stroke_width = 0.05em
      #place(
        dx: -square_width - square_padding,
        dy: 0em,
        grid(
          columns: (auto, auto),
          align: horizon,
          gutter: 0.1em,
          box(
            width: 0.15em,
            height: bracket_height,
            stroke: (
              rest: bracket_stroke_width + square_color,
              right: none,
            ),
            outset: (right: -0.04em),
          ),
          box(
            width: square_width,
            height: square_width,
            fill: square_color,
            radius: 0.01em,
          ),
        ),
      )
      #h(-0.12em)
      #text(
        weight: 700,
        font: "STIX Two Text",
        fill: color.darken(13%),
        counter(heading).display(it.numbering),
      )
      #h(0.5em)
      #text(
        weight: 700,
        font: "Baskervville",
        tracking: 0.1pt,
        fill: color.darken(20%),
        it.body,
      )
    ]
    #v(-0.7em)
    #rect(
      width: 100%,
      height: line_width,
      fill: color,
      stroke: none,
      radius: 0.03em,
      outset: (x: 2em),
    )
    // #let pat = tiling(size: (10pt, 10pt))[
    //   #place(line(start: (0%, 100%), end: (100%, 0%), stroke: oklch(68.69%, 0.078, 165.61deg).lighten(30%) + 0.5pt))
    // ]
    // #v(-1.4em)
    //     #rect(
    //       width: 100%,
    //       height: 6pt,
    //       fill: pat,
    //       stroke: none,
    //       radius: 0.03em,
    //       outset: (x: 2em),
    //     )
    // #v(-1.4em)
    // #rect(
    //   width: 30%,
    //   height: 1.7pt,
    //   fill: oklch(68.69%, 0.078, 165.61deg),
    //   stroke: none,
    //   radius: 0.001em,
    //   outset: (x: -2em),
    // )
    #v(0.4em)

  ]
}


#let section_style_3(it, color: oklch(76.38%, 0.065, 93.48deg)) = {
  // rect(
  //   width: 10%,
  //   height: 5em,
  //   stroke: none,
  //   fill: oklch(37.46%, 0.057, 238.87deg),
  //   outset: (x: 50%),
  // )
  rect(
    width: 100%,
    height: 4em,
    stroke: (left: 3em + color),
    fill: color.lighten(75%).desaturate(85%),
    outset: (x: 5em),
    {
      set align(horizon)
      set par(first-line-indent: 0pt)
      set text(size: 21pt)

      let num = counter(heading).display(it.numbering)
      let width = measure(num).width
      let gap = 1em
      block({
        place(
          dx: -(width + gap),
          text(
            weight: 700,
            font: "STIX Two Text",
            baseline: 0.05em,
            fill: color.darken(2%).saturate(20%),
            counter(heading).display(it.numbering),
          ),
        )
        h(-0.1em)
        text(
          weight: 700,
          font: "Baskervville",
          tracking: 0.1pt,
          fill: color.darken(2%).saturate(20%),
          it.body,
        )
      })
    },
  )
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
    section_style_2(it)
    // section_style_2(it, color: oklch(62.7%, 0.053, 172.77deg))
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
