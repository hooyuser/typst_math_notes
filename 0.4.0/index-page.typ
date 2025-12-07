#import "@preview/in-dexter:0.7.2": index, make-index

#let index_math = index.with(index: "Math")

// -----------------------------------------------------------------
// Index Chapters
// -----------------------------------------------------------------
#let index_chapters = [
  #pagebreak(weak: true)

  #set heading(numbering: none)

  #let gen_index = make-index.with(
    use-page-counter: true,
    sort-order: upper,
    section-title: (letter, counter) => {
      set align(center)
      block(
        fill: orange.desaturate(79%),
        width: 100%,
        inset: (left: 0.5em, right: 0.5em, y: 0.45em),
        outset: (x: 0.2em),
        radius: 0.15em,
        text(
          weight: 800,
          14pt,
          tracking: 0.5pt,
          font: "Lato",
          fill: rgb("#ff6f00"),
        )[
          #letter
        ],
      )
    },
    section-body: (letter, counter, body) => {
      body
      v(1em)
    },
  )

  = Notation Index #metadata("index")

  #columns(3, gutter: 5% + 0pt)[
    #gen_index(indexes: "Math")
  ]

  #pagebreak(weak: true)
  = Subject Index #metadata("index")

  #columns(2, gutter: 8% + 0pt)[
    #gen_index(indexes: "Default")
  ]
]
