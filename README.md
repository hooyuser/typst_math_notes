# Typst template for math notes

Example

```typ
#import "@local/math-notes:0.2.0": *

#show: math_notes.with(
  title: [ELLIPTIC CURVES],
)

#block(inset: (left: -0.5em, right: -0.5em))[
  #outline(title: text(font: "Noto Sans", size: 23pt, weight: 700, stretch: 150%)[Contents #v(1em)], depth: 3)
]

#pagebreak()

= Linear Algebra

#definition[
  Linear Space
][
  A vector space over a field F is a non-empty set V together with a binary operation and a binary function.
]
```
