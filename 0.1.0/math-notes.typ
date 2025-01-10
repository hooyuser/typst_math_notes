#import "@preview/ctheorems:1.1.3": *

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


// Theorem environment
#let thm_env_head_sans(name, color) = [#text(font: "Latin Modern Sans", weight: 500, fill: color)[#name]]

#let thm_env_name_sans(name, color) = [#text(font: "Noto Sans Display", weight: 500, fill: color, size: 10.5pt)[#name]]



#let quoteblock(background_color, front_color, bar_width: 0.25em, inset: 1em, contents) = pad(
  left: 0.5 * bar_width,
  block(
    fill: none,
    stroke: (left: bar_width + background_color),
    pad(left: 0.5 * bar_width, block(fill: front_color, width: 100%, inset: inset, contents)),
  ),
)

// Theorem environment for definition, lemma, proposition, corollary
#let thmbox_quote(
  identifier,
  head,
  ..blockargs,
  supplement: auto,
  padding: (left: 0.3em),
  namefmt: x => [(#x)],
  numberfmt: x => x,
  titlefmt: strong,
  bodyfmt: x => x,
  separator: [#h(0.1em):#h(0.2em)],
  base: "heading",
  base_level: none,
  front_color: luma(230),
  background_color: luma(30),
) = {
  if supplement == auto {
    supplement = head
  }
  let boxfmt(name, number, body, title: auto, ..blockargs_individual) = {
    set block(breakable: true)
    set par(first-line-indent: 0pt)

    if not name == none {
      name = [ #namefmt(name) ]
    } else {
      name = []
    }
    if title == auto {
      title = head
    }
    if not number == none {
      title += h(0.15em) + numberfmt(number)
    }
    title = titlefmt(title)
    body = bodyfmt(body)
    quoteblock(front_color, background_color)[#title#h(2pt)#name#separator#v(3pt)#body]
  }
  return thmenv(identifier, base, base_level, boxfmt).with(supplement: supplement)
}

#let thmbox_quote_style(identifier, head, front_color, background_color) = thmbox_quote(
  identifier,
  thm_env_head_sans(head, front_color),
  separator: [ \ ],
  namefmt: x => thm_env_name_sans(x, front_color),
  numberfmt: x => thm_env_head_sans(x, front_color),
  fill: background_color,
  breakable: true,
  front_color: front_color,
  background_color: background_color,
  base_level: 2,
  supplement: head,
)

// Theorem environment for example
#let thmbox_frame(
  identifier,
  head,
  ..blockargs,
  supplement: auto,
  padding: (top: 0.25em, bottom: 0.25em),
  namefmt: x => [(#x)],
  numberfmt: x => x,
  titlefmt: strong,
  bodyfmt: x => x,
  separator: [#h(0.1em):#h(0.2em)],
  base: "heading",
  base_level: none,
) = {
  if supplement == auto {
    supplement = head
  }
  let boxfmt(name, number, body, title: auto, ..blockargs_individual) = {
    set par(first-line-indent: 0pt)
    if not name == none {
      name = [ #namefmt(name) ]
    } else {
      name = []
    }
    if title == auto {
      title = head
    }
    if not number == none {
      title += " " + numberfmt(number)
    }
    title = titlefmt(title)
    body = bodyfmt(body)
    pad(
      ..padding,
      block(
        width: 100%,
        inset: 1.2em,
        radius: 0.3em,
        breakable: false,
        ..blockargs.named(),
        ..blockargs_individual.named(),
        [#title#name#separator#v(3pt)#body],
      ),
    )
  }
  return thmenv(identifier, base, base_level, boxfmt).with(supplement: supplement)
}


// convert list of pairs to dictionary
#let dict_from_pairs(pairs) = {
  for pair in pairs {
    assert(pair.len() == 2, message: "`from_pairs` accepts an array of pairs")
    (pair.at(0): pair.at(1))
  }
}

// color dictionary for theorem environments
#let thm_env_color_dict = (
  theorem: (front: rgb("#f19000"), background: rgb("#fdf8ea")),
  proposition: (front: rgb("#30773c"), background: rgb("#ebf4ec")),
  lemma: (front: rgb("#907a6b"), background: rgb("#f6f4f2")),
  corollary: (front: rgb("#a74eb4"), background: rgb("#f9effb")),
  definition: (front: rgb("#000069"), background: rgb("#f2f2f9")),
)

// generate theorem environments from color dictionary
#let gen_thm_envs(name_color_dict) = {
  let theorem_envs = name_color_dict.pairs().map(((env_name, env_colors)) => {
    // capitalize the first letter of the environment name
    let header = upper(env_name.first()) + env_name.slice(1)
    (env_name, thmbox_quote_style("theorem", header, env_colors.front, env_colors.background))
  })
  // convert list of pairs to dictionary to enable matching by environment name
  dict_from_pairs(theorem_envs)
}


// Export theorem environments
#let (definition, proposition, lemma, theorem, corollary) = gen_thm_envs(thm_env_color_dict)

#let example = thmbox_frame(
  "example",
  thm_env_head_sans("Example", rgb("#2a7f7f")),
  separator: [ \ ],
  namefmt: x => thm_env_name_sans(x, rgb("#2a7f7f")),
  numberfmt: x => thm_env_head_sans(x, rgb("#2a7f7f")),
  fill: rgb("#f2fbf8"),
  stroke: rgb("#88d6d1") + 1pt,
  breakable: true,
  base_level: 2,
  supplement: "Example",
)

#let proof = thmproof("proof", "Proof", separator: [.])

#let remark = thmproof("remark", "Remark", separator: [.])


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
  show: thmrules.with(qed-symbol: $square$)

  // setting reference style
  show ref: set text(rgb("#395094"))

  // setting link style
  show link: set text(rgb("#395094"))

  set math.mat(delim: "[")
  set math.vec(delim: "[")


  // Title Page
  v(1fr)
  align(center)[
    #text(font: title_font, size: 35pt, weight: 500, ligatures: false)[#smallcaps(title)]
    #v(1.5fr)
    #text(font: title_font, size: 15pt, datetime.today().display())
  ]
  v(1.2fr)

  pagebreak()

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

      let chapter_dict_final =  chapter_dict.final()
      let page_num_str = str(absolute_page_number)
      let is_first_page_of_chapter = page_num_str in chapter_dict_final


      let chapters = heading.where(level: 1)
      let sections = heading.where(level: 2)
      // get the chapter number of the current chapter
      let chapter_number = counter(chapters).display()

      // get the chapter-section number of the current section
      let section_counter = counter(chapters.or(sections)).display()
      let section_number = if section_counter.len() <= 1 {""} else {
      section_counter}

      if is_first_page_of_chapter {
        current_chapter.update(chapter_dict_final.at(page_num_str))
        current_section.update("")
      }
      else {
        let chapter_name = current_chapter.get()
        let section_name = current_section.get()
        [*#chapter_number #upper(chapter_name)* #h(1fr) #smallcaps[#section_number #section_name]]
        // [#chapter_name#h(1fr)#section_name]
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

