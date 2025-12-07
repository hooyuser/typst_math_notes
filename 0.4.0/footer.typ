// -----------------------------------------------------------------
// Footer Definition
// -----------------------------------------------------------------

#let footer-progress-bar = context {
  let page_number = counter(page).get().first()
  let total_page_number = counter(page).final().first()
  let ratio = (page_number - 1) / (total_page_number - 1 + 0.00001) // avoid division by zero
  set align(right)
  stack(
    dir: ltr,
    move(dy: 0.92em, line(
      length: ratio * 100%,
      stroke: (
        paint: luma(70%),
        cap: "round",
        thickness: 0.7pt,
      ),
    )),
    move(dy: 0.92em, line(
      length: (1 - ratio) * 100%,
      stroke: (
        paint: luma(70%),
        cap: "round",
        thickness: 0.7pt,
        dash: (0.45em, 0.3em),
      ),
    )),
  )
  move(dy: -0.9em, dx: 2.6em, box(height: 1.6em, width: 1.6em, fill: luma(65%), radius: 0.33em)[
    #set align(center + horizon)
    #set text(font: "Noto Sans", size: 8pt, weight: 600, fill: luma(99%))
    #page_number
  ])
}
