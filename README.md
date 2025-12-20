# Typst template for math notes

Example

```typ
#import "@local/math-notes:0.4.0": *

#show: math_notes.with(
  title: [ELLIPTIC CURVES],
)

= Linear Algebra

#definition[
  Linear Space
][
  A vector space over a field $F$ is a non-empty set $V$ together with a binary operation and a binary function.
]
```
