#import "icon_font.typ": icon
// -----------------------------------------------------------------
// Outline Style
//
// Usage:
//
//   show outline.entry: outline_style.with(
//     outline_color: rgb("f36619")
//   )
// -----------------------------------------------------------------
#let outline_style(it, outline_color: black) = {
  set text(font: "Noto Sans")
  show link: set text(black)
  let fill_line_color = luma(70%)
  let indents = ("l1": 32pt, "l2": 28pt, "l3": 30pt) //indents for numbering
  let extra_paddings = ("l2": 1pt, "l3": 2pt)
  //let indents = ("l1": 30pt, "l2": 28pt, "l3": 25pt)
  let loc = it.element.location()
  let page_number = it.page() // page number
  let chapter_idx = it.prefix()
  let header_text = it.element.body
  let level2_padding = 2pt
  let level3_padding = 1pt
  let vline_color = outline_color.darken(0%)

  let content_line = if it.level == 1 {
    set text(size: 16pt, weight: 700, fill: outline_color)
    v(26pt, weak: true)
    let inset_left = 0.5em
    box(
      inset: (left: -inset_left),
      grid(
        columns: (indents.l1 + inset_left, auto),
        align: horizon,
        circle(
          radius: 15.65pt,
          stroke: 0.1pt + outline_color,
          fill: outline_color.lighten(82%),
        )[
          #set align(center + horizon)
          #let chapter_number = if chapter_idx != none {
            chapter_idx
          } else {
            icon("boxdashed")
          }
          #text(size: 17pt, fill: outline_color.saturate(0%), chapter_number)
        ],
        grid.cell[
          #header_text
          #h(1fr)
          #page_number
        ]
      ),
    )
    v(-10pt, weak: true)
  } else if it.level == 2 {
    v(10pt, weak: true)
    set text(size: 12pt, weight: 600)
    h(indents.l1 + extra_paddings.l2) // level2_padding as extra padding
    box(width: indents.l2, chapter_idx)
    header_text
    h(0.4em)
    box(
      stroke: none,
      width: 1fr,
      inset: (y: 0.0em),
      line(length: 100%, stroke: fill_line_color + .5pt),
    )
    h(0.4em)
    page_number
  } else if it.level == 3 {
    v(8pt, weak: true)
    let is_first = chapter_idx.text.last() == "1"
    set text(size: 9.5pt, weight: 400, fill: luma(15%))

    let vline_offset = indents.l1 + extra_paddings.l2 + 0.9em // 0.9em needs to fine-tuned for the vertical line
    let vline_y_padding = 0.2em
    let outset_top = if is_first {
      vline_y_padding
    } else {
      1em - vline_y_padding
    }
    box(
      stroke: (left: 2pt + vline_color),
      outset: (left: -vline_offset, top: outset_top, bottom: vline_y_padding),
      {
        h(indents.l1 + indents.l2 + extra_paddings.l3) // level3_padding as extra padding
        box(width: indents.l3, chapter_idx)
        header_text
        h(1fr)
        page_number
      },
    )
  }
  link(loc, content_line)
}
