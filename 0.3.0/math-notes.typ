#import "theme.typ": theme_dict, theme_state, with_theme_config
#import "theorem-environment.typ": (
  proof_env_generator, quote_style_theorem, rounded_block, theorem_env_generator, theorem_env_initiate,
)

#import "outline.typ": outline_style

#import "@preview/in-dexter:0.7.2": make-index



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
    set par(first-line-indent: 0em)
    text(weight: 700, 22pt, tracking: 0.5pt, font: "Lato", fill: chapter_color)[
      #v(2em)
      Chapter #counter(heading).display(it.numbering)#v(1.1em, weak: true)
    ]
    text(weight: 700, 28pt, font: "Lato", ligatures: false)[
      #it.body #v(2em, weak: true)
    ]
  } else if it.level == 2 {
    set text(16pt, weight: 700, font: "New Computer Modern")
    it
  } else if it.level == 3 {
    set text(13pt, weight: 700, font: "New Computer Modern")
    it
  } else {
    set text(weight: 700, font: "New Computer Modern")
    it
  }
}


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
      current-env.update("none") // exit the current theorem environment and reset the state
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
    current-env.update("none") // exit the current theorem environment and reset the state
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

  pagebreak()
}

#let index_chapters = [
  #pagebreak()

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

  #pagebreak()
  = Subject Index #metadata("index")

  #columns(2, gutter: 8% + 0pt)[
    #gen_index(indexes: "Default")
  ]
]


// -----------------------------------------------------------------
// Math Notes Template
// -----------------------------------------------------------------



#let math_notes(doc, title: "TITLE", title_font: "Noto Serif", theme: "light") = {
  context theme_state.update(sys.inputs.at("notes-theme", default: theme)) // allow cli to override theme
  set text(fallback: false)

  let theme_config = theme_dict.at(theme)
  let page_background_color = theme_config.background
  set page(
    margin: 1.9cm,
    fill: page_background_color,
    header-ascent: 40% + 0pt,
  )


  set heading(numbering: "1.1")
  //set par(leading: 0.55em, first-line-indent: 1.8em, justify: true)

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


  // setting for enumeration and list
  set enum(indent: 0.45em, body-indent: 0.45em, numbering: "(i)", start: 1, spacing: 1em)
  set list(indent: 0.45em, body-indent: 0.45em)

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
  show heading: heading_style.with(chapter_color: theme_config.chapter_color)

  // setting for outline "#4682b4"
  show outline.entry: outline_style.with(color_dict: theme_config.outline_color_dict)

  // setting for theorem environment
  show: theorem_env_initiate

  // setting reference style
  //let ref_color = theme_config.ref_color
  show ref: set text(theme_config.ref_color)

  // setting link style
  show link: set text(theme_config.ref_color)

  set math.mat(delim: "[")
  set math.vec(delim: "[")
  set math.cases(gap: 0% + 1em)


  // Title Page
  title_page(title: title, title_font: title_font)


  // Table of Contents
  block(inset: (left: -0.5em, right: -0.5em))[
    #outline(title: text(font: "Noto Sans", size: 23pt, weight: 700, stretch: 150%)[Contents #v(1em)], depth: 3)
  ]
  pagebreak()

  // Set the main text paragraph style
  set par(leading: 0.7em, spacing: 1em, first-line-indent: 1.8em, justify: true)

  // Set Header and Footer

  // Define state for header and footer
  // Set Header and Footer
  let chapter_dict = state("chapter_dict", (:))
  let current_chapter = state("current_chapter", "")
  let current_section = state("current_section", "")


  show heading.where(level: 1): curr-heading => (
    {
      curr-heading // preserve heading style, only add side effect
      let chapter_page_number = str(here().page())
      let current_numbering = curr-heading.numbering

      chapter_dict.update(headings => {
        // if one page have more than one chapter, only keep the first one
        if chapter_page_number not in headings {
          let chapter_num = if headings.len() == 0 {
            0
          } else {
            let last_heading_values = headings.values().last()
            if current_numbering != last_heading_values.at(1) {
              0
            } else {
              last_heading_values.at(0)
            }
          }
          headings.insert(chapter_page_number, (chapter_num + 1, current_numbering, curr-heading.body))
        }
        headings
      })
    }
  )

  show heading.where(level: 2): curr-heading => {
    curr-heading
    current_section.update(curr-heading.body)
  }

  set page(
    number-align: center,
    header: context {
      // get the absolute page number of the current page

      let absolute_page_number = here().page()

      let chapter_dict_final = chapter_dict.final()
      let page_num_str = str(absolute_page_number)
      let is_first_page_of_chapter = page_num_str in chapter_dict_final


      let chapters = heading.where(level: 1)
      let sections = heading.where(level: 2)


      // get the first section after the current location
      let after_here_section = query(sections.after(here())).at(0, default: none)

      // get the location of the first section after the current location
      let after_here_section_loc = if after_here_section != none {
        after_here_section.location()
      }

      // get the page number of the first section after the current location
      let after_here_section_page = if after_here_section != none {
        after_here_section_loc.page()
      }

      // get the y position of the first section after the current location
      let after_here_section_pos = if after_here_section != none {
        after_here_section_loc.position().y
      }

      // calculate top margin
      let top_margin = if page.margin == auto or type(page.margin) == dictionary and page.margin.top == auto {
        let small-side = calc.min(page.height, page.width)
        (2.5 / 21) * small-side // According to docs, this is the 'auto' margin
      } else {
        if type(page.margin) == relative {
          measure(line(length: page.margin)).width
        } else {
          measure(line(length: page.margin.top)).width
        }
      } // Not sure about this implementation


      // check if the first line of the current page is a new section
      // check if the first line of the current page is a new section
      let first_line_is_new_section = (
        after_here_section_pos != none
          and absolute_page_number == after_here_section_page
          and after_here_section_pos < top_margin + 0.01pt
      )

      // if the current page is the first page of a chapter, then display nothing
      if is_first_page_of_chapter {
        current_chapter.update(chapter_dict_final.at(page_num_str))
        current_section.update("")
      } else {
        // if the current page is not the first page of a chapter

        // get the chapter number before the current location
        // let chapter_number = counter(chapters).display()
        // let chapter_name = current_chapter.get()
        let (chapter_num, chapter_numbering, chapter_name) = current_chapter.get()
        if chapter_numbering == none {
          return
        }
        let chapter_number = numbering(chapter_numbering, chapter_num)

        let (section_number, section_name) = if first_line_is_new_section and after_here_section != none {
          // count all sections before the first section after the current location (including the the first section after the current location)
          let section_num = counter(heading).at(after_here_section_loc).at(1)
          let section_number = numbering(chapter_numbering, chapter_num, section_num)
          let section_name = after_here_section.body
          (section_number, section_name)
        } else if counter(chapters.or(sections)).get().len() == 1 {
          // if no section before current location
          ("", "")
        } else {
          // count all sections before the current location
          let section_num = counter(chapters.or(sections)).get().at(1)
          let section_number = numbering(chapter_numbering, chapter_num, section_num)
          let section_name = current_section.get()
          (section_number, section_name)
        }
        [
          #set text(font: "Noto Sans", fill: luma(45%))
          #h(-2.1em)
          #smallcaps[*#chapter_number | #chapter_name*] #h(1fr)#set text(
            font: "Noto Sans",
            size: 10pt,
            weight: 600,
            fill: luma(45%),
          )
          #section_number | #section_name
          #h(-2.1em)
        ]
      }
    },


    // header: context {

    //   let chapters = heading.where(level: 1)
    //   let sections = heading.where(level: 2)

    //   // get an array of all chapters before current location
    //   let chapters_before = query(chapters.before(here()))

    //   // get an array of all chapters after current location
    //   let chapters_after = query(chapters.after(here()))

    //   // get an array of all sections before current location
    //   let sections_before = query(sections.before(here()))

    //   // display nothing if query result is empty
    //   if chapters_before.len() == 0 or chapters_after.len() == 0 or sections_before.len() == 0 {
    //     return
    //   }

    //   // get the absolute page number of the first page of the current chapter
    //   let chapter_absolute_page_number = chapters_after.first().location().page()

    //   // get the absolute page number of the current page
    //   let absolute_page_number = here().page()

    //   // if the current page is the first page of a chapter, then display nothing
    //   if absolute_page_number == chapter_absolute_page_number {
    //     return
    //   }

    //   // get the chapter number of the current chapter
    //   let chapter_number = counter(chapters).display()

    //   // get the chapter-section number of the current section
    //   let section_number = counter(chapters.or(sections)).display()

    //   // get the current chapter name
    //   let chapter_name = chapters_before.last().body

    //   // get the current section name
    //   let section_name = sections_before.last().body

    //   [*#chapter_number #upper(chapter_name)* #h(1fr) #smallcaps[#section_number #section_name]]

    // },
    footer: context {
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


      // if calc.odd(page_number) {
      //   set align(right)
      //   // counter(page).display("i")
      //   circle(radius: auto, fill: luma(50%))[
      //     #set align(center + horizon)
      //     #set text(font: "Noto Sans", size: 10pt, weight: 600, fill: luma(95%))
      //     #page_number
      //   ]
      // } else {
      //   set align(right)
      //   circle(radius: auto, fill: luma(50%))[
      //     #set align(center + horizon)
      //     #set text(font: "Noto Sans", size: 10pt, weight: 600, fill: luma(95%))
      //     #page_number
      //   ]
      // }
    },
  )

  // Start counting pages from here
  counter(page).update(1)

  // Main content
  doc

  index_chapters
}

