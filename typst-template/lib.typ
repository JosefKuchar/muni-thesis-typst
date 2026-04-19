#let body_fonts = ("TeX Gyre Pagella", "Palatino Linotype", "Book Antiqua", "New Computer Modern")
#let sans_fonts = ("TeX Gyre Heros", "Arial", "New Computer Modern")
#let thesis_blue = rgb("#0000dc")
#let latex_pdflatex_sans_scale = 0.863
#let typst_titlepage_sans_correction = 0.83
#let body_page_margin = (left: 44.5mm, right: 38.5mm, top: 46mm, bottom: 31mm)
#let front_matter_page_margin = (left: 44.5mm, right: 38.5mm, top: 46mm, bottom: 60mm)

#let university_logo_color = image("/assets/base-english-color.svg", width: 61mm)
#let university_logo_mono = image("/assets/base-english-mono.svg", width: 61mm)
#let faculty_logo_color = image("/assets/fi-color.svg", width: 45mm)

// fithesis under pdfTeX uses tgheros scaled to 0.863. Typst uses the OTF
// fonts directly, which renders slightly larger, so we keep one explicit
// template-level correction here instead of tuning individual lines.
#let titlepage_font_size(size) = {
  size * latex_pdflatex_sans_scale * typst_titlepage_sans_correction * 1pt
}

#let chapter(title) = {
  pagebreak(weak: true)
  heading(level: 1)[#title]
}

#let chapter_star(title) = {
  pagebreak(weak: true)
  heading(level: 1, numbering: none, outlined: true)[#title]
}

#let front_title(title) = block(
  text(
    font: body_fonts,
    size: 18pt,
    weight: "bold",
  )[#title],
)

#let sans_line(body, size: 18pt, weight: "regular", fill: black) = align(
  center,
  text(font: sans_fonts, size: size, weight: weight, fill: fill)[#body],
)

#let centered_at(dy, body) = place(top + center, dy: dy)[#body]

#let centered_titlepage_text(
  body,
  size,
  weight: "regular",
  fill: black,
  width: auto,
) = align(center)[
  #block(width: width)[
    #set par(justify: false)
    #text(font: sans_fonts, size: size, weight: weight, fill: fill)[#body]
  ]
]

#let cover_page(
  faculty_name,
  title,
  thesis_type,
  author,
  place_name,
  semester,
) = [
  #set page(margin: 0mm, numbering: none)
  #align(center)[
    #v(46.5mm)
    #image("/assets/base-english-mono.svg", width: 61.2mm)
    #v(10.7mm)
    #centered_titlepage_text(
      upper(faculty_name),
      titlepage_font_size(18),
    )
    #v(0.42fr)
    #centered_titlepage_text(
      title,
      titlepage_font_size(30),
      weight: "bold",
      width: 129mm,
    )
    #v(15mm)
    #centered_titlepage_text(
      thesis_type,
      titlepage_font_size(22),
    )
    #v(15mm)
    #centered_titlepage_text(
      upper(author),
      titlepage_font_size(25),
    )
    #v(1.7fr)
    #centered_titlepage_text(
      [#place_name, #semester],
      titlepage_font_size(18),
    )
    #v(43mm)
  ]
]

#let title_page(
  faculty_name,
  title,
  thesis_type,
  author,
  advisor,
  department,
  place_name,
  semester,
) = [
  #set page(margin: 0mm, numbering: "i", number-align: bottom + right)
  #centered_at(44mm, university_logo_color)
  #centered_at(72.9mm, text(font: sans_fonts, size: titlepage_font_size(18))[#upper(faculty_name)])
  #centered_at(98.8mm, text(font: sans_fonts, size: titlepage_font_size(30), weight: "bold", fill: thesis_blue)[#title])
  #centered_at(124.0mm, text(font: sans_fonts, size: titlepage_font_size(22))[#thesis_type])
  #centered_at(147.0mm, text(font: sans_fonts, size: titlepage_font_size(25))[#upper(author)])
  #centered_at(191.7mm, text(font: sans_fonts, size: titlepage_font_size(18))[Advisor: #advisor])
  #centered_at(205.6mm, text(font: sans_fonts, size: titlepage_font_size(18))[#department])
  #centered_at(230.4mm, text(font: sans_fonts, size: titlepage_font_size(18))[#(place_name + ", " + semester)])
]

#let seal_page() = [
  #set page(margin: 0mm, numbering: "i", number-align: bottom + right)
  #v(79mm)
  #align(center)[#faculty_logo_color]
]

#let declaration_page(title, body, author, advisor) = [
  #set page(margin: front_matter_page_margin, numbering: "i", number-align: bottom + right)
  #set par(first-line-indent: 0pt, justify: true, leading: 2.5pt)
  #front_title(title)
  #v(3mm)
  #body
  #v(12mm)
  #align(right)[#author]
  #v(1fr)
  #strong[Advisor:] #advisor
]

#let thanks_page(title, body) = [
  #set page(margin: front_matter_page_margin, numbering: "i", number-align: bottom + right)
  #set par(first-line-indent: 0pt, justify: false, leading: 2.5pt)
  #v(171mm)
  #front_title(title)
  #v(3mm)
  #body
]

#let abstract_keywords_page(
  abstract_title,
  abstract_body,
  keywords_title,
  keywords,
) = [
  #set page(margin: front_matter_page_margin, numbering: "i", number-align: bottom + right)
  #set par(first-line-indent: 0pt, justify: false, leading: 2.5pt)
  #front_title(abstract_title)
  #v(3mm)
  #abstract_body
  #v(1fr)
  #front_title(keywords_title)
  #v(3mm)
  #keywords.join(", ")
]

#let outline_fill = repeat([.], gap: 0.28em)

#let body_page_number(loc) = {
  let values = counter(page).at(loc)
  if values.len() == 0 { none } else { values.first() }
}

#let heading_outline_prefix(entry) = {
  if entry.numbering == none {
    none
  } else {
    context numbering(entry.numbering, ..counter(heading).at(entry.location()))
  }
}

#let chapter_number_at(loc) = {
  let values = counter(heading.where(level: 1)).at(loc)
  if values.len() == 0 { none } else { values.first() }
}

#let figure_outline_prefix(entries, index) = {
  let chapter = chapter_number_at(entries.at(index).location())
  if chapter == none {
    none
  } else {
    let local_index = entries
      .slice(0, index + 1)
      .filter(entry => chapter_number_at(entry.location()) == chapter)
      .len()
    numbering("1.1", chapter, local_index)
  }
}

#let top_level_outline_entry(prefix, body, page) = block(above: 8pt)[
  #text(weight: "bold")[
    #if prefix != none [#prefix #h(0.45em)]
    #body
  ]
  #h(1fr)
  #page
]

#let nested_outline_entry(indent, prefix, body, page) = block[
  #h(indent)
  #if prefix != none [#prefix #h(0.45em)]
  #body
  #box(width: 1fr, outline_fill)
  #page
]

#let contents_page(title) = [
  #set page(margin: body_page_margin, numbering: "i", number-align: bottom + right)
  #set par(first-line-indent: 0pt)
  #front_title(title)
  #v(6mm)
  #context {
    let entries = query(heading.where(outlined: true))
      .filter(entry => entry.level <= 3)

    for entry in entries {
      let prefix = heading_outline_prefix(entry)
      let page = body_page_number(entry.location())

      if entry.level == 1 {
        link(
          entry.location(),
          top_level_outline_entry(prefix, entry.body, page),
        )
      } else if entry.level == 2 {
        link(
          entry.location(),
          nested_outline_entry(1.8em, prefix, entry.body, page),
        )
      } else {
        link(
          entry.location(),
          nested_outline_entry(5.2em, prefix, entry.body, page),
        )
      }
    }
  }
]

#let listing_page(title, kind) = [
  #set page(margin: body_page_margin, numbering: "i", number-align: bottom + right)
  #set par(first-line-indent: 0pt)
  #front_title(title)
  #v(6mm)
  #context {
    let entries = query(figure.where(kind: kind, outlined: true))

    for (index, entry) in entries.enumerate() {
      let prefix = figure_outline_prefix(entries, index)
      let page = body_page_number(entry.location())

      link(
        entry.location(),
        nested_outline_entry(0pt, prefix, entry.caption.body, page),
      )
    }
  }
]

#let fithesis(
  title: [],
  author: [],
  advisor: [],
  department: [],
  faculty_name: [Faculty of Informatics],
  thesis_type: [Bachelor's Thesis],
  place: "Brno",
  semester: "Spring 2026",
  declaration_title: [Declaration],
  declaration_body: [],
  thanks_title: [Acknowledgements],
  thanks_body: [],
  abstract_title: [Abstract],
  abstract_body: [],
  keywords_title: [Keywords],
  keywords: (),
  contents_title: [Contents],
  list_of_tables_title: [List of Tables],
  list_of_figures_title: [List of Figures],
  show_list_of_tables: true,
  show_list_of_figures: true,
  doc,
) = {
  set text(font: body_fonts, size: 12pt)
  set par(first-line-indent: 1.5em, justify: true, leading: 2.5pt)
  set heading(numbering: "1.1.1")
  set outline(indent: auto)
  show heading.where(level: 1): it => block(
    above: 0pt,
    below: 20pt,
    text(font: body_fonts, size: 18pt, weight: "bold")[
      #if it.numbering == none {
        it.body
      } else {
        [#counter(heading).display(it.numbering) #h(0.45em) #it.body]
      }
    ],
  )
  show heading.where(level: 2): it => block(
    above: 8pt,
    below: 8pt,
    text(font: body_fonts, size: 14pt, weight: "bold")[
      #counter(heading).display(it.numbering) #h(0.45em) #it.body
    ],
  )
  show heading.where(level: 3): it => block(
    above: 8pt,
    below: 8pt,
    text(font: body_fonts, size: 12pt, weight: "bold")[
      #counter(heading).display(it.numbering) #h(0.45em) #it.body
    ],
  )
  show figure.caption: it => text(font: body_fonts, size: 12pt)[#it.body]
  show strong: it => text(weight: "bold", font: body_fonts)[#it.body]

  [
    #cover_page(
      faculty_name,
      title,
      thesis_type,
      author,
      place,
      semester,
    )
    #pagebreak()

    #counter(page).update(1)
    #title_page(
      faculty_name,
      title,
      thesis_type,
      author,
      advisor,
      department,
      place,
      semester,
    )
    #pagebreak()

    #seal_page()
    #pagebreak()

    #declaration_page(
      declaration_title,
      declaration_body,
      author,
      advisor,
    )
    #pagebreak()

    #thanks_page(
      thanks_title,
      thanks_body,
    )
    #pagebreak()

    #abstract_keywords_page(
      abstract_title,
      abstract_body,
      keywords_title,
      keywords,
    )
    #pagebreak()

    #contents_page(contents_title)
    #if show_list_of_tables [
      #pagebreak()
      #listing_page(
        list_of_tables_title,
        table,
      )
    ]
    #if show_list_of_figures [
      #pagebreak()
      #listing_page(
        list_of_figures_title,
        image,
      )
    ]

    #pagebreak()
    #set page(margin: body_page_margin, numbering: "1", number-align: bottom + right)
    #counter(page).update(1)
    #doc
  ]
}
