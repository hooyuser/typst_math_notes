#import "@preview/rich-counters:0.2.2": *

#set heading(numbering: "1.1")
// #set page(margin: (top: 5em, bottom: 5em))
#set par(justify: true)



#let thm_env_head_sans(name) = [#text(font: "Latin Modern Sans", weight: 700)[#name]]

#let thm_env_name_sans(name) = [#text(font: "Noto Sans Display", weight: 500, size: 10.5pt)[#name]]

// Here are some predefined theorem styles


#let quote_block(
  stroke_color: black,
  fill_color: gray,
  bar_width: 0.25em,
  inset: 1em,
) = block.with(
  stroke: (left: bar_width + stroke_color),
  fill: fill_color,
  outset: (left: -0.5 * bar_width),
  inset: (x: bar_width + inset, y: inset),
  width: 100%,
)

#let rounded_block(
  stroke_color: black,
  fill_color: gray,
  radius: 0.3em,
  inset: (x: 1.25em, y: 1em),
) = block.with(
  stroke: (1pt + stroke_color),
  fill: fill_color,
  inset: inset,
  radius: radius,
  width: 100%,
)

#let theorem_env(
  env_name,
  counter_identifier,
  title,
  content,
  header_color,
  block_func,
) = figure(
  supplement: env_name,
  kind: "thm-env-counted",
)[
  #let counter = rich-counter(
    identifier: counter_identifier,
    inherited_levels: 2,
  )
  #(counter.step)()
  #metadata(loc => { std.numbering("1.1", ..((counter.at)(loc))) })
  #label("thm-env:number-func")
  #block_func[
    #set align(start)
    #let theorem_prefix = thm_env_head_sans(env_name)
    #let theorem_number = thm_env_head_sans(context (counter.display)())
    #let theorem_title = thm_env_name_sans(title)
    #text(
      fill: header_color,
      theorem_prefix + h(0.15em) + theorem_number + h(0.3em) + theorem_title + h(1fr),
    )
    #v(-0.3em)
    #content
  ]]



// Define custom reference function
#show ref: it => {
  if it.element != none and it.element.func() == figure and it.element.kind == "thm-env-counted" {
    let supplement = if it.citation.supplement != none { it.citation.supplement } else { it.element.supplement }
    let data = query(selector(label("thm-env:number-func")).after(it.target)).first()
    let numberfunc = data.value
    link(it.target, [#supplement #numberfunc(data.location())])
  } else {
    it
  }
}

#let proof_env(
  content,
  prefix: text(style: "oblique", [Proof.]),
  suffix: h(1fr) + $square$,
  block_func: block,
) = figure(
  block_func(prefix + content + suffix),
  kind: "thm-env-uncounted",
  supplement: "Proof",
  outlined: false,
)


#let thm_env_color_dict = (
  theorem: (front: rgb("#f19000"), background: rgb("#fdf8ea")),
  proposition: (front: rgb("#30773c"), background: rgb("#ebf4ec")),
  lemma: (front: rgb("#907a6b"), background: rgb("#f6f4f2")),
  corollary: (front: rgb("#a74eb4"), background: rgb("#f9effb")),
  definition: (front: rgb("#000069"), background: rgb("#f2f2f9")),
)


#let theorem_env_generator(
  env_name,
  env_class: "theorem",
  header_color: black,
  block_func: block,
) = (
  title,
  content,
) => theorem_env(
  env_name,
  env_class,
  title,
  content,
  header_color,
  block_func,
)


// color dictionary for theorem environments
#let thm_env_color_dict = (
  theorem: (front: rgb("#f19000"), background: rgb("#fdf8ea")),
  proposition: (front: rgb("#30773c"), background: rgb("#ebf4ec")),
  lemma: (front: rgb("#907a6b"), background: rgb("#f6f4f2")),
  corollary: (front: rgb("#a74eb4"), background: rgb("#f9effb")),
  definition: (front: rgb("#000069"), background: rgb("#f2f2f9")),
)

#let dict_from_pairs(pairs) = {
  for pair in pairs {
    assert(pair.len() == 2, message: "`from_pairs` accepts an array of pairs")
    (pair.at(0): pair.at(1))
  }
}

//env_class: "theorem", front_color: black, background_color: gray, block_func

// generate theorem environments from color dictionary
#let gen_thm_envs(name_color_dict) = {
  let theorem_envs = name_color_dict
    .pairs()
    .map(((env_name, env_colors)) => {
      // capitalize the first letter of the environment name
      let header = upper(env_name.first()) + env_name.slice(1)
      let (front_color, background_color) = (env_colors.front, env_colors.background)
      (
        env_name,
        theorem_env_generator(
          header,
          env_class: "theorem",
          header_color: front_color,
          block_func: quote_block(
            stroke_color: front_color,
            fill_color: background_color,
          ),
        ),
      )
    })
  // convert list of pairs to dictionary to enable matching by environment name
  dict_from_pairs(theorem_envs)
}


// Export theorem environments
#let (definition, proposition, lemma, theorem, corollary) = gen_thm_envs(thm_env_color_dict)

#let example_env_colors = (
  frame: rgb("#88d6d1"),
  background: rgb("#f2fbf8"),
  header: rgb("#2a7f7f"),
)

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

#let proof_block = block.with(
  inset: (x: 1em, y: 1em),
  width: 100%,
)

#let proof_env_generator(
  title: "Proof",
  suffix: [#h(1fr) $square$],
  block_func: proof_block,
) = content => proof_env(
  content,
  prefix: text(style: "oblique", [#title. ]),
  suffix: suffix,
  block_func: block_func,
)

#let proof = proof_env_generator(title: "Proof")
#let remark = proof_env_generator(title: "Proof")


#show figure.where(kind: "thm-env-counted"): set block(breakable: true)
#show figure.where(kind: "thm-env-counted"): set align(start)
#show figure.where(kind: "thm-env-uncounted"): set block(breakable: true)
#show figure.where(kind: "thm-env-uncounted"): set align(start)
