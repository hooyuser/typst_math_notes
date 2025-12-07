#import "theme.typ": theme_dict, theme_state, with_theme_config
#import "theorem-environment.typ": (
  proof_env_generator, quote_style_theorem, rounded_block, theorem_env_generator, theorem_env_initiate,
)

#import "outline.typ": outline_style
#import "heading.typ": heading_style
#import "header.typ": header-chapter-section, heading_lv1_wrapper, heading_lv2_wrapper
#import "footer.typ": footer-progress-bar
#import "index-page.typ": index_chapters


// -----------------------------------------------------------------
// Theorem Environments
// -----------------------------------------------------------------

#let current-env = state("math-notes.current-env", none)
#let current-env-name() = current-env.get()

// wrap with a figure as a temporary fix
#let theorem_func(env_name, ..env_body) = {
  let header = upper(env_name.first()) + env_name.slice(1) // capitalize the first letter of the environment name
  figure(
    with_theme_config(theme_config => {
      let color_dict = theme_config.at("thm_env_color_dict")
      let env_colors = color_dict.at(env_name)
      current-env.update(env_name) // set state to the current environment name, so we know which environment we are in currently
      quote_style_theorem(header, env_colors, ..env_body)
      current-env.update(none) // exit the current theorem environment and reset the state
    }),
    kind: "thm-env-counted",
    supplement: header,
  )
}

#let gen_theorem_func_from_name(env_name) = theorem_func.with(env_name)


#let (definition, proposition, lemma, theorem, corollary) = for name in theme_dict.light.thm_env_color_dict.keys() {
  ((name): gen_theorem_func_from_name(name))
}


// Export example environment
#let example = (..body) => figure(
  with_theme_config(theme_config => {
    let (frame, background, header) = theme_config.at("example_env_color_dict")
    current-env.update("example") // set state to the current environment name, so we know which environment we are in currently
    theorem_env_generator(
      "Example",
      env_class: "example",
      header_color: header,
      block_func: rounded_block(
        stroke_color: frame,
        fill_color: background,
      ),
    )(..body)
    current-env.update(none) // exit the current theorem environment and reset the state
  }),
  kind: "thm-env-counted",
  supplement: "Example",
)


// Theorem environment for proof and remark
#let proof = proof_env_generator(title: "Proof")
#let remark = proof_env_generator(
  title: "Remark",
  suffix: [#text(fill: oklch(28%, 0, 0deg, 70%), baseline: -0.05em)[#box(
      width: 0pt,
    )#h(1fr)#sym.wj#sym.space.nobreak$square.filled#h(-0.09em)$]],
)


// -----------------------------------------------------------------
// Title Page
// -----------------------------------------------------------------

#let title_page(title: "TITLE", title_font: "Noto Serif") = {
  // Title Page
  v(1fr)
  align(center)[
    #text(font: title_font, size: 35pt, weight: 500, ligatures: false)[#smallcaps(title)]
    #v(1.5fr)
    #text(font: title_font, size: 15pt, datetime.today().display())
  ]
  v(1.2fr)

  pagebreak(weak: true)
}


// -----------------------------------------------------------------
// Math Notes Template
// -----------------------------------------------------------------

#let math_notes(doc, title: "TITLE", theme: "light") = {
  context theme_state.update(sys.inputs.at("notes-theme", default: theme)) // allow cli to override theme
  set text(fallback: false)

  let theme_config = theme_dict.at(theme)
  let page_background_color = theme_config.background

  set page(
    margin: 1.9cm,
    fill: page_background_color,
    header-ascent: 40% + 0pt,
  )

  // set font for document text
  // #set text(font: "New Computer Modern", size: 11pt, fallback: false)
  let text_color = theme_config.text
  set text(font: "STIX Two Text", size: 11pt, fallback: false, fill: text_color)
  set strong(delta: 200)

  // set font for math text
  // #show math.equation: set text(font: "STIX Two Math", weight: 400)
  show math.equation: set text(
    font: (
      (name: "Computer Modern Symbol", covers: regex("[𝒜ℬ𝒞𝒟ℰℱ𝒢ℋℐ𝒥𝒦ℒℳ𝒩-𝒬ℛ𝒮-𝒵]")),
      "New Computer Modern Math",
    ),
    weight: 450, // default weight is 450, just to be explicit here
    features: ("cv01",), // enable wide empty set symbol
    fallback: false,
  )
  show math.equation: set block(below: 8pt, above: 9pt)
  //#show raw: set text(font: "New Computer Modern Mono")


  // setting for enumeration
  // set enum(
  //   indent: 0.45em,
  //   body-indent: 0.45em,
  //   numbering: "(i)",
  //   start: 1,
  //   spacing: 1em,
  // )
  show enum: x => v(0.3em) + x
  set enum(
    indent: 0.05em,
    body-indent: 0.55em, // Increased slightly to give the circle breathing room
    start: 1,
    spacing: 1em,
    numbering: n => {
      // 1. Get the roman numeral string (i, ii, iii)
      let num = numbering("i", n)

      // 2. Create the visual component
      with_theme_config(theme => context {
        let thm-env = current-env-name()
        let front-color = if thm-env == none {
          oklch(36%, 0, 0deg, 70%)
        } else if thm-env == "example" {
          theme.at("example_env_color_dict").at("header")
        } else {
          theme.at("thm_env_color_dict").at(thm-env).at("front")
        }

        let background-color = if thm-env == none {
          oklch(86.81%, 0, 26.57deg, 66.5%)
        } else if thm-env == "example" {
          theme.at("example_env_color_dict").at("frame").lighten(50%).desaturate(20%)
        } else {
          theme.at("thm_env_color_dict").at(thm-env).at("secondary")
        }

        pad(
          circle(
            radius: if thm-env == none { 0.57em } else { 0.6em }, // Size of the circle

            fill: background-color,
          )[
            // 3. Style the text inside the circle
            #set align(center + horizon)
            #set text(fill: front-color, size: 0.8em, weight: 600, font: "Inter 18pt")
            #num
          ],
          top: -0.2em,
        )
      })
    },
  )


  // setting for bullet list
  set list(
    indent: 0em,
    body-indent: 0.38em,
    marker: (
      with_theme_config(theme => context {
        let thm-env = current-env-name()
        let front-color = if thm-env == none {
          oklch(46.06%, 0.089, 94.84deg, 66.5%)
          return box(height: 0.6em, align(horizon, text(size: 1.25em)[•]))
        } else if thm-env == "example" {
          theme.at("example_env_color_dict").at("header")
        } else {
          theme.at("thm_env_color_dict").at(thm-env).at("front").desaturate(20%)
        }
        box(height: 0.5em, align(horizon, text(size: 1.7em, fill: front-color)[•]))
      }),
      text(fallback: true, "▪"),
    ), // workaround
  )

  // guarantee that equations take the full width of the page
  show enum: it => {
    show math.equation.where(block: true): eq => {
      block(width: 100%, inset: 0pt, align(center, eq))
    }
    it
  }

  show list: it => {
    show math.equation.where(block: true): eq => {
      block(width: 100%, inset: 0pt, align(center, eq))
    }
    it
  }

  // setting for heading
  set heading(numbering: "1.1")
  show heading: heading_style.with(chapter_color: theme_config.chapter_color)

  // setting for outline
  show outline.entry: outline_style.with(color_dict: theme_config.outline_color_dict)

  // setting for theorem environment
  show: theorem_env_initiate

  // setting reference style
  show ref: set text(theme_config.ref_color)

  // setting link style
  show link: set text(theme_config.ref_color)

  // setting for math style
  set math.mat(delim: "[")
  set math.vec(delim: "[")
  set math.cases(gap: 0% + 1em)

  // -----------------------------------------------------------------
  // Start of Document
  // -----------------------------------------------------------------

  // Title Page
  title_page(title: title, title_font: "Noto Serif")

  // Table of Contents
  block(inset: (left: -0.5em, right: -0.5em))[
    #outline(title: text(font: "Noto Sans", size: 23pt, weight: 700, stretch: 150%)[Contents #v(1em)], depth: 3)
  ]
  pagebreak(weak: true)

  // Set the main text paragraph style
  set par(leading: 0.7em, spacing: 1em, first-line-indent: 1.8em, justify: true)

  // Wrap heading to update header info
  show heading.where(level: 1): heading_lv1_wrapper
  show heading.where(level: 2): heading_lv2_wrapper

  set page(
    header: header-chapter-section, // Set Header
    footer: footer-progress-bar, // Set Footer
  )

  // Start counting pages from here
  counter(page).update(1)

  // Main content
  doc

  // Notation Index and Subject Index
  index_chapters
}

