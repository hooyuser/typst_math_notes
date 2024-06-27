
#import "@preview/ctheorems:1.1.2": *


#let outline_style(it, outline_color: black) = {
  set text(font: "Noto Sans")
  let fill_line_color = luma(70%)
  let indents = ("l1": 30pt, "l2": 28pt, "l3": 25pt)
  let loc = it.element.location()
  let page_number = it.page // page number
  let (chapter_idx, _, header_text, ..) = it.body.children
   
  let content_line = if it.level == 1 {
    v(26pt, weak: true)
    text(size: 15pt, weight: 700, fill: outline_color)[
      #box(stroke: none, width: indents.l1, inset: (y: 0.0em), chapter_idx)
      #header_text
      #h(1fr)
      #page_number 
    ]
  } else if it.level == 2 {
    v(10pt, weak: true)
    text(size: 10pt, weight: 500)[
      #box(stroke: none, width: indents.l1 + 2pt) // 2pt extra padding
      #box(stroke: none, width: indents.l2, chapter_idx)
      #header_text 
      #h(0.2em) 
      #box(stroke: none, width: 1fr, inset: (y: 0.0em), line(length: 100%, stroke: fill_line_color + .5pt)) 
      #h(0.2em) 
      #page_number
    ]
  } else if it.level == 3 {
    v(8pt, weak: true)
    text(size: 9pt, weight: 400, fill: luma(15%))[
      #box(stroke: none, width: indents.l1 + 2pt)
      #box(stroke: none, width: indents.l2 + 1pt) // 1pt extra padding
      #box(stroke: none, width: indents.l3, chapter_idx)
      #header_text 
      #h(1fr) 
      #page_number
    ]
  }
  link(loc, content_line)
}

#let heading_style(it) = {
  set block(above: 1.4em, below: 1em)
   
  if it.numbering == none {
    it
  } else if it.level == 1 {
    set par(first-line-indent: 0em)
    text(weight: 550, 22pt, tracking: 0.5pt, font: "Lato", fill: luma(30%))[
      #v(2em)
      Chapter #counter(heading).display(it.numbering)#v(1.1em, weak: true)
    ]
    text(weight: 600, 28pt, font: "Lato", ligatures: false)[
      #it.body #v(2em, weak: true)
    ]
  } else if it.level == 2 {
    set text(16pt, weight: 600, font: "New Computer Modern")
    it
  } else if it.level == 3 {
    set text(13pt, weight: 600, font: "New Computer Modern")
    it
  } else {
    it
  }
} 


// Theorem environment
#let thm_env_head_sans(name, color) = [#text(font: "Latin Modern Sans", weight: 700, fill: color)[#name]]

#let thm_env_name_sans(name, color) = [#text(font: "Noto Sans Display", weight: 500, fill: color, size: 10.5pt)[#name]]


#let theorem_color = rgb("#f19000")
#let theorem_color_bg = rgb("#fdf8ea")



#let quoteblock(background_color, front_color, bar_width: 0.25em, inset: 1em, contents) = pad(left: 0.5 * bar_width, block(
  fill: none,
  stroke: (left: bar_width + background_color),
  pad(left: 0.5 * bar_width, block(fill: front_color, width: 100%, inset: inset, contents)),
))

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
)

// Theorem environment for example
#let thmbox_frame(
  identifier,
  head,
  ..blockargs,
  supplement: auto,
  padding: (top: 0.5em, bottom: 0.5em),
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
    pad(..padding, block(
      width: 100%,
      inset: 1.2em,
      radius: 0.3em,
      breakable: false,
      ..blockargs.named(),
      ..blockargs_individual.named(),
      [#title#name#separator#v(3pt)#body],
    ))
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
)

#let proof = thmproof("proof", "Proof", separator: [.])


#let math_notes(doc) = {
  //#set page(width: 16cm, height: auto, margin: 1.5cm)
  set page(margin: 1.9cm)
  set heading(numbering: "1.1")
  set par(leading: 0.55em, first-line-indent: 1.8em, justify: true)
   
  // set font for document text
  // #set text(font: "New Computer Modern", size: 11pt, fallback: false)
  set text(font: "STIX Two Text", size: 11pt, fallback: false)
   
  // set font for math text
  // #show math.equation: set text(font: "STIX Two Math", weight: 400)
  show math.equation: set text(font: "New Computer Modern Math", weight: 450, fallback: false)
  show math.equation: set block(below: 8pt, above: 9pt)
  //#show raw: set text(font: "New Computer Modern Mono")
   
  set strong(delta: 200)
   
  // setting for enumeration and list 
  set enum(indent: 0.45em, body-indent: 0.45em, numbering: "(i)", start: 1)
  set list(indent: 0.45em, body-indent: 0.45em)
   
   
  // setting for paragraph
  show par: set block(spacing: 0.55em)
   
  // setting for heading
  show heading: heading_style
   
  // setting for outline
  show outline.entry: outline_style.with(outline_color: rgb("#4682b4"))
   
  // setting for theorem environment
  show: thmrules.with(qed-symbol: $square$)
   
  doc
}

