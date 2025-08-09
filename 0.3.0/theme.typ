
// -----------------------------------------------------------------
// Theme
// -----------------------------------------------------------------
#let theme_dict = (
  light: (
    text: oklch(18%, 0, 0deg),
    background: oklch(98%, 0, 95deg),
    chapter_color: oklch(45%, 0, 0deg),
    ref_color: rgb("#395094"),
    thm_env_color_dict: (
      theorem: (front: rgb("#f19000"), background: rgb("#fdf8ea")),
      proposition: (front: oklch(57%, 0.14, 147deg), background: oklch(95.8%, 0.01, 147deg)),
      lemma: (front: rgb("#907a6b"), background: rgb("#f6f4f2")),
      corollary: (front: rgb("#a74eb4"), background: rgb("#f9effb")),
      definition: (front: oklch(45.68%, 0.14, 263.66deg), background: rgb("#f2f2f9")),
    ),
    example_env_color_dict: (
      frame: rgb("#88d6d1"),
      background: rgb("#f2fbf8"),
      header: rgb("#2a7f7f"),
    ),
    outline_color_dict: (
      l1: rgb("f36619"),
      l2: luma(0%),
      l3: luma(15%),
    ),
  ),
  dark: (
    text: luma(89.87%),
    background: rgb("#292B2E"),
    chapter_color: luma(74.51%),
    ref_color: rgb("#8f9fcf"),
    thm_env_color_dict: (
      theorem: (front: rgb("#f19000"), background: rgb("#3d3220")),
      proposition: (front: rgb("#8cd898"), background: rgb("#2a3b2a")),
      lemma: (front: rgb("#d3a280"), background: rgb("#3b3731")),
      corollary: (front: rgb("#a74eb4"), background: rgb("#3d2f3d")),
      definition: (front: rgb("#6aaeed"), background: rgb("#2f2f3d")),
    ),
    example_env_color_dict: (
      frame: rgb("#74b7b2"),
      background: rgb("#323737"),
      header: rgb("#7ed0d0"),
    ),
    outline_color_dict: (
      l1: rgb("f36619"),
      l2: luma(89.87%),
      l3: luma(77%),
    ),
  ),
)

#let theme_state = state("math-notes-theme", none)

#let with_theme_config(fn) = context {
  let theme = state("math-notes-theme").get()
  fn(theme_dict.at(theme))
}

