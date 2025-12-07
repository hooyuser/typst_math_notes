// Define state for header
#let chapter_dict = state("chapter_dict", (:))
#let current_chapter = state("current_chapter", "")
#let current_section = state("current_section", "")


// Heading Lv1 Wrapper
#let heading_lv1_wrapper(curr-heading) = {
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


// Heading Lv2 Wrapper
#let heading_lv2_wrapper(curr-heading) = {
  curr-heading
  current_section.update(curr-heading.body)
}



// -----------------------------------------------------------------
// Header function
// -----------------------------------------------------------------
#let header-chapter-section = context {
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
      #smallcaps[*#chapter_number #text(baseline: -0.07em)[|] #chapter_name*] #h(1fr)#set text(
        font: "Noto Sans",
        size: 10pt,
        weight: 600,
        fill: luma(45%),
      )
      #section_number #text(baseline: -0.07em)[|] #section_name
      #h(-2.1em)
    ]
  }
}
