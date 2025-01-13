#import "@preview/rich-counters:0.2.2": rich-counter

#set heading(numbering: "1.1")
// #set page(margin: (top: 5em, bottom: 5em))
#set par(justify: true)

// Set font for theorem environment prefix (e.g. "Theorem 1.1.2")
#let thm_env_head_sans(name) = [#text(font: "Latin Modern Sans", weight: 700)[#name]]
// Set font for theorem environment titles (e.g. "Fermat Last Theorem")
#let thm_env_name_sans(name) = [#text(font: "Noto Sans Display", weight: 500, size: 10.5pt)[#name]]

// -----------------------------------------------------------------
// Theorem Environment Block Presets
// -----------------------------------------------------------------

// Here are some predefined theorem styles
// Block with a colored background and a colored stroke on the left
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

// Block with rounded corners
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

// Plain block with no special styling
#let proof_block(
  inset: (x: 1em, top: 0em, bottom: 1em),
) = block.with(
  inset: inset,
  width: 100%,
)



// -----------------------------------------------------------------
// Theorem Environment Definitions
// -----------------------------------------------------------------

// Define theorem environment
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
    #set par(first-line-indent: 0pt)
    #let theorem_prefix = thm_env_head_sans(env_name)
    #let theorem_number = thm_env_head_sans(context (counter.display)())
    #let theorem_title = thm_env_name_sans(title)
    #text(
      fill: header_color,
      theorem_prefix + h(0.15em) + theorem_number + h(0.3em) + theorem_title + h(1fr),
    )

    #v(0.1em)
    #content
  ]
]

// Define proof environment
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

// -----------------------------------------------------------------
// Theorem Environment Generators
// -----------------------------------------------------------------

// Define theorem environment generator, returns a theorem environment API for exporting
// - If there is only one argument input_1, then content = input_1
// - If there are two arguments input_1 and input_2, then (title, content) = (input_1, input_2)
#let theorem_env_generator(
  env_name,
  env_class: "theorem",
  header_color: black,
  block_func: block,
) = (
  input_1,
  ..input_2,
) => {
  if input_2.named().len() > 0 {
    panic("Theorem environment does not accept named arguments")
  }
  if input_2.pos().len() == 0 {
    theorem_env(
      env_name,
      env_class,
      "",
      input_1,
      header_color,
      block_func,
    )
  } else if input_2.pos().len() == 1 {
    theorem_env(
      env_name,
      env_class,
      input_1,
      input_2.at(0),
      header_color,
      block_func,
    )
  } else {
    panic("Theorem environment accepts at most two arguments")
  }
}

#let proof_env_generator(
  title: "Proof",
  suffix: [#h(1fr) $square$],
  block_func: proof_block(),
) = content => proof_env(
  content,
  prefix: text(style: "oblique", [#title. ]),
  suffix: suffix,
  block_func: block_func,
)


// Utility function to generate a dictionary from an array of pairs
#let dict_from_pairs(pairs) = {
  for pair in pairs {
    assert(pair.len() == 2, message: "`from_pairs` accepts an array of pairs")
    (pair.at(0): pair.at(1))
  }
}

// Utility function to generate theorem environments from color dictionary
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

// -----------------------------------------------------------------
// Theorem Environment Initializer
// -----------------------------------------------------------------


// Use `show: theorem_env_initiate` to initiate theorem environments
#let theorem_env_initiate(body) = {
  show figure.where(kind: "thm-env-counted"): set block(breakable: true)
  show figure.where(kind: "thm-env-counted"): set align(start)
  show figure.where(kind: "thm-env-counted"): fig => fig.body

  show figure.where(kind: "thm-env-uncounted"): set block(breakable: true)
  show figure.where(kind: "thm-env-uncounted"): set align(start)
  show figure.where(kind: "thm-env-uncounted"): fig => fig.body

  // Define custom reference function
  show ref: it => {
    if it.element != none and it.element.func() == figure and it.element.kind == "thm-env-counted" {
      let supplement = if it.citation.supplement != none { it.citation.supplement } else { it.element.supplement }
      let data = query(selector(label("thm-env:number-func")).after(it.target)).first()
      let numberfunc = data.value
      link(it.target, [#supplement #numberfunc(data.location())])
    } else {
      it
    }
  }

  body
}
