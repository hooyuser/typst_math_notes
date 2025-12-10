
// -----------------------------------------------------------------
// Theme
// -----------------------------------------------------------------
#let theme_dict = (
  light: (
    text_color: oklch(18%, 0, 0deg),
    text_font: "STIX Two Text",
    math_color: oklch(18%, 0, 0deg),
    background: oklch(98%, 0, 95deg),
    chapter_color: oklch(45%, 0, 0deg),
    section_color: oklch(60.82%, 0.126, 210deg),
    subsection_color: oklch(35%, 0, 0deg),
    ref_color: rgb("#395094"),
    thm_env_color_dict: (
      theorem: (
        front: oklch(73.91%, 0.167, 64.39deg),
        secondary: oklch(93.74%, 0.10, 66.96deg, 80%),
        background: rgb("#fdf8ea"),
      ),
      proposition: (
        front: oklch(57%, 0.14, 147deg),
        secondary: oklch(91.09%, 0.047, 149.33deg, 80%),
        background: oklch(95.8%, 0.01, 147deg),
      ),
      lemma: (
        front: oklch(59.58%, 0.035, 56.23deg),
        secondary: oklch(90.99%, 0.011, 56.68deg, 80%),
        background: rgb("#f6f4f2"),
      ),
      corollary: (
        front: oklch(57.53%, 0.174, 322.39deg),
        secondary: oklch(91.86%, 0.063, 322.15deg, 80%),
        background: rgb("#f9effb"),
      ),
      definition: (
        front: oklch(45.68%, 0.14, 263.66deg),
        secondary: oklch(91.74%, 0.039, 265.29deg, 80%),
        background: rgb("#f2f2f9"),
      ),
      proof: oklch(28%, 0, 0deg, 80%),
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
    text_color: luma(74%),
    text_font: "Fira Sans",
    math_color: luma(83%),
    background: rgb("#292B2E"),
    chapter_color: luma(74.51%),
    section_color: oklch(80.48%, 0.124, 50.36deg),
    subsection_color: oklch(72%, 0.048, 71.2deg),
    ref_color: rgb("#8f9fcf"),
    thm_env_color_dict: (
      theorem: (
        front: oklch(73.91%, 0.167, 64.39deg),
        secondary: oklch(43.74%, 0.10, 66.96deg, 80%),
        background: oklch(36.08%, 0.029, 81.78deg),
      ),
      proposition: (
        front: oklch(81.6%, 0.117, 148.37deg),
        secondary: oklch(40.09%, 0.027, 149.33deg, 80%),
        background: oklch(33.19%, 0.037, 144.69deg),
      ),
      lemma: (
        front: oklch(74.95%, 0.075, 56.05deg),
        secondary: oklch(40.99%, 0.011, 56.68deg, 80%),
        background: oklch(33.89%, 0.012, 78.16deg),
      ),
      corollary: (
        front: oklch(57.53%, 0.174, 322.39deg),
        secondary: oklch(42.86%, 0.063, 322.15deg, 80%),
        background: oklch(32.64%, 0.031, 326.26deg),
      ),
      definition: (
        front: oklch(73.13%, 0.115, 247.9deg),
        secondary: oklch(41.74%, 0.039, 265.29deg, 80%),
        background: oklch(31.12%, 0.025, 284.86deg),
      ),
      proof: luma(89.87%),
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

