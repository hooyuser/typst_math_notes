#let icon_text(unicode, ..args) = {
  text(font: "Icon Design", top-edge: "bounds", bottom-edge: "bounds", unicode, ..args)
}

#let name_unicode_map = (
  "boxdashed": "\u{F000}",
)

#let icon(name, ..args) = {
  icon_text.with(name_unicode_map.at(name))(..args)
}
