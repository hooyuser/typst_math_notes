#import "theorem-environment.typ": (
  theorem_env_initiate,
  theorem_env_generator,
  proof_env_generator,
  gen_thm_envs,
  rounded_block,
)


// -----------------------------------------------------------------
// Outline Style
// -----------------------------------------------------------------
#let outline_style(it, outline_color: black) = {
  set text(font: "Noto Sans")
  show link: set text(black)
  let fill_line_color = luma(70%)
  let indents = ("l1": 32pt, "l2": 28pt, "l3": 30pt) //indents for numbering
  let extra_paddings = ("l2": 1pt, "l3": 2pt)
  //let indents = ("l1": 30pt, "l2": 28pt, "l3": 25pt)
  let loc = it.element.location()
  let page_number = it.page // page number
  let chapter_idx = it.body.children.at(0)
  let header_text = it.element.body
  let level2_padding = 2pt
  let level3_padding = 1pt
  let vline_color = rgb("f36619").darken(0%)

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
          stroke: 0.1pt + outline_color,
          fill: outline_color.lighten(82%),
        )[
          #set align(center + horizon)
          #text(size: 17pt, fill: outline_color.saturate(0%), chapter_idx)
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


// -----------------------------------------------------------------
// Heading Style
// -----------------------------------------------------------------
#let heading_style(it) = {
  set block(above: 1.4em, below: 1em)

  if it.numbering == none {
    it
  } else if it.level == 1 {
    set par(first-line-indent: 0em)
    text(weight: 700, 22pt, tracking: 0.5pt, font: "Lato", fill: luma(30%))[
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

// Define theorem environments
#let thm_env_color_dict = (
  theorem: (front: rgb("#f19000"), background: rgb("#fdf8ea")),
  proposition: (front: rgb("#30773c"), background: rgb("#ebf4ec")),
  lemma: (front: rgb("#907a6b"), background: rgb("#f6f4f2")),
  corollary: (front: rgb("#a74eb4"), background: rgb("#f9effb")),
  definition: (front: rgb("#000069"), background: rgb("#f2f2f9")),
)
// Export theorem environments
#let (definition, proposition, lemma, theorem, corollary) = gen_thm_envs(thm_env_color_dict)


// Define theorem environment for example
#let example_env_colors = (
  frame: rgb("#88d6d1"),
  background: rgb("#f2fbf8"),
  header: rgb("#2a7f7f"),
)
// Export example environment
#let example = {
  let (frame, background, header) = (example_env_colors.frame, example_env_colors.background, example_env_colors.header)
  theorem_env_generator(
    "Example",
    env_class: "example",
    header_color: header,
    block_func: rounded_block(
      stroke_color: frame,
      fill_color: background,
    ),
  )
}

// Theorem environment for proof and remark
#let proof = proof_env_generator(title: "Proof")
#let remark = proof_env_generator(title: "Remark")


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


// -----------------------------------------------------------------
// Math Notes Template
// -----------------------------------------------------------------

#let math_notes(doc, title: "TITLE", title_font: "Noto Serif") = {
  set text(fallback: false)
  set page(margin: 1.9cm)


  set heading(numbering: "1.1")
  set par(leading: 0.55em, first-line-indent: 1.8em, justify: true)

  // set font for document text
  // #set text(font: "New Computer Modern", size: 11pt, fallback: false)
  set text(font: "STIX Two Text", size: 11pt, fallback: false)
  set strong(delta: 200)

  // set font for math text
  // #show math.equation: set text(font: "STIX Two Math", weight: 400)
  show math.equation: set text(font: "New Computer Modern Math", weight: 450, features: ("cv01",), fallback: false)
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

  // setting for paragraph
  set par(leading: 0.7em, spacing: 1em)

  // setting for heading
  show heading: heading_style

  // setting for outline "#4682b4"
  show outline.entry: outline_style.with(outline_color: rgb("f36619"))

  // setting for theorem environment
  show: theorem_env_initiate

  // setting reference style
  show ref: set text(rgb("#395094"))

  // setting link style
  show link: set text(rgb("#395094"))

  set math.mat(delim: "[")
  set math.vec(delim: "[")


  // Title Page
  title_page(title: title, title_font: title_font)


  // Table of Contents
  block(inset: (left: -0.5em, right: -0.5em))[
    #outline(title: text(font: "Noto Sans", size: 23pt, weight: 700, stretch: 150%)[Contents #v(1em)], depth: 3)
  ]
  pagebreak()

  // Set Header and Footer

  // Define state for header and footer
  // Set Header and Footer
  let chapter_dict = state("chapter_dict", (:))
  let current_chapter = state("current_chapterg", "")
  let current_section = state("current_section", "")


  show heading.where(level: 1): curr-heading => (
    context {
      curr-heading // preserve heading style, only add side effect
      let chapter_page_number = str(here().page())
      chapter_dict.update(headings => {
        // if one page have more than one chapter, only keep the first one
        if chapter_page_number not in headings {
          headings.insert(chapter_page_number, curr-heading.body)
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
        let chapter_number = counter(chapters).display()
        let chapter_name = current_chapter.get()

        let (section_number, section_name) = if first_line_is_new_section and after_here_section != none {
          // count all sections before the first section after the current location (including the the first section after the current location)
          let section_number = counter(heading).at(after_here_section_loc).map(str).join(".")
          let section_name = after_here_section.body
          (section_number, section_name)
        } else {
          // count all sections before the current location
          let section_counter = counter(chapters.or(sections)).display()
          let section_name = current_section.get()
          (section_counter, section_name)
        }
        [*#chapter_number #upper(chapter_name)* #h(1fr) #smallcaps[#section_number #section_name]]
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
    // footer: context {
    //   let page_number = counter(page).get().first()

    //   if calc.odd(page_number) {
    //     set align(left)
    //     // counter(page).display("i")
    //     circle(radius: auto, fill: orange)[
    //       #set align(center + horizon)
    //       #page_number
    //     ]
    //   } else {
    //     set align(right)
    //     circle(radius: auto, fill: orange)[
    //       #set align(center + horizon)

    //       #page_number
    //     ]
    //   }
    // },
  )

  // Start counting pages from here
  counter(page).update(1)

  // Main content
  doc
}

