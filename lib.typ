#let body_fonts = ("TeX Gyre Pagella", "Palatino Linotype", "Book Antiqua", "New Computer Modern")
#let sans_fonts = ("TeX Gyre Heros", "Arial", "New Computer Modern")
#let thesis_blue = rgb("#0000dc")
#let latex_pdflatex_sans_scale = 0.863
#let typst_titlepage_sans_correction = 0.83
#let body_font_size = 12pt
#let body_leading = 6.25pt
#let body_page_margin = (left: 44.5mm, right: 38.5mm, top: 46mm, bottom: 58mm)
#let front_matter_page_margin = (left: 44.5mm, right: 38.5mm, top: 46mm, bottom: 60mm)
#let front_matter_footer_descent = 0% + 24pt
#let body_footer_descent = 0% + 20pt
#let running_header_rule_gap = -2pt
#let figure_spacing_above = 14pt
#let figure_spacing_below = 12pt
#let figure_caption_gap = 12pt
#let equation_spacing_above = 10pt
#let equation_spacing_below = 10pt

#let university_logo_color = image("/assets/base-english-color.svg", width: 61mm)
#let university_logo_mono = image("/assets/base-english-mono.svg", width: 61mm)
#let faculty_logo_color = image("/assets/fi-color.svg", width: 40mm)

// fithesis under pdfTeX uses tgheros scaled to 0.863. Typst uses the OTF
// fonts directly, which renders slightly larger, so we keep one explicit
// template-level correction here instead of tuning individual lines.
#let titlepage_font_size(size) = {
  size * latex_pdflatex_sans_scale * typst_titlepage_sans_correction * 1pt
}

#let chapter(title) = {
  heading(level: 1)[#title]
}

#let chapter_star(title) = {
  heading(level: 1, numbering: none, outlined: true)[#title]
}

#let front_title(title) = block(
  text(
    font: body_fonts,
    size: 18pt,
    weight: "bold",
    tracking: -0.3pt,
  )[#title],
)

#let sans_line(body, size: 18pt, weight: "regular", fill: black) = align(
  center,
  text(font: sans_fonts, size: size, weight: weight, fill: fill)[#body],
)

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
    #v(46mm)
    #image("/assets/base-english-mono.svg", width: 61.2mm)
    #v(9mm)
    #centered_titlepage_text(
      upper(faculty_name),
      titlepage_font_size(18),
    )
    #v(22mm)
    #centered_titlepage_text(
      title,
      titlepage_font_size(30),
      weight: "bold",
      width: 129mm,
    )
    #v(16mm)
    #centered_titlepage_text(
      thesis_type,
      titlepage_font_size(22),
    )
    #v(18mm)
    #centered_titlepage_text(
      upper(author),
      titlepage_font_size(25),
    )
    #v(0.7fr)
    #centered_titlepage_text(
      [#place_name, #semester],
      titlepage_font_size(18),
    )
    #v(63mm)
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
  #set page(
    margin: 0mm,
    numbering: "i",
    number-align: bottom + right,
    footer-descent: front_matter_footer_descent,
  )
  #align(center)[
    #v(46mm)
    #university_logo_color
    #v(9mm)
    #centered_titlepage_text(
      upper(faculty_name),
      titlepage_font_size(18),
    )
    #v(22mm)
    #centered_titlepage_text(
      title,
      titlepage_font_size(30),
      weight: "bold",
      fill: thesis_blue,
      width: 129mm,
    )
    #v(16mm)
    #centered_titlepage_text(
      thesis_type,
      titlepage_font_size(22),
    )
    #v(18mm)
    #centered_titlepage_text(
      upper(author),
      titlepage_font_size(25),
    )
    #v(1fr)
    #centered_titlepage_text(
      [Advisor: #advisor],
      titlepage_font_size(18),
    )
    #v(8mm)
    #centered_titlepage_text(
      department,
      titlepage_font_size(18),
    )
    #v(20mm)
    #centered_titlepage_text(
      [#place_name, #semester],
      titlepage_font_size(18),
    )
    #v(63mm)
  ]
]

#let seal_page() = [
  #set page(
    margin: 0mm,
    numbering: "i",
    number-align: bottom + right,
    footer-descent: front_matter_footer_descent,
  )
  #v(79mm)
  #align(center)[#faculty_logo_color]
]

#let declaration_page(title, body, author, advisor) = [
  #set page(
    margin: front_matter_page_margin,
    numbering: "i",
    number-align: bottom + right,
    footer-descent: front_matter_footer_descent,
  )
  #set text(size: body_font_size)
  #set par(first-line-indent: 0pt, justify: true, leading: body_leading)
  #front_title(title)
  #v(7mm)
  #body
  #v(20mm)
  #align(right)[#author]
  #v(1fr)
  #strong[Advisor:] #advisor
]

#let thanks_page(title, body) = [
  #set page(
    margin: front_matter_page_margin,
    numbering: "i",
    number-align: bottom + right,
    footer-descent: front_matter_footer_descent,
  )
  #set text(size: body_font_size)
  #set par(first-line-indent: 0pt, justify: false, leading: body_leading)
  #v(1fr)
  #front_title(title)
  #v(7mm)
  #body
]

#let abstract_keywords_page(
  abstract_title,
  abstract_body,
  keywords_title,
  keywords,
) = [
  #set page(
    margin: front_matter_page_margin,
    numbering: "i",
    number-align: bottom + right,
    footer-descent: front_matter_footer_descent,
  )
  #set text(size: body_font_size)
  #set par(first-line-indent: 0pt, justify: false, leading: body_leading)
  #front_title(abstract_title)
  #v(7mm)
  #abstract_body
  #v(1fr)
  #front_title(keywords_title)
  #v(7mm)
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
    let local_index = entries.slice(0, index + 1).filter(entry => chapter_number_at(entry.location()) == chapter).len()
    numbering("1.1", chapter, local_index)
  }
}

#let figure_caption_label(kind) = {
  if kind == table { "Table" } else { "Figure" }
}

#let figure_caption_prefix(kind) = context {
  let chapter_values = counter(heading.where(level: 1)).get()
  let figure_values = counter(figure.where(kind: kind)).get()
  if chapter_values.len() == 0 or figure_values.len() == 0 {
    none
  } else {
    let chapter = chapter_values.first()
    let index = figure_values.first()
    [#figure_caption_label(kind) #numbering("1.1", chapter, index)]
  }
}

#let body_running_header() = context {
  let page_values = counter(page).get()
  if page_values.len() == 0 {
    none
  } else {
    let current_page = page_values.first()
    let level_one_headings = query(heading.where(level: 1, outlined: true))
    let opens_on_current_page = level_one_headings.any(entry => {
      let page = body_page_number(entry.location())
      page != none and page == current_page
    })
    let chapters = level_one_headings
      .filter(entry => entry.numbering != none)
      .filter(entry => {
        let page = body_page_number(entry.location())
        page != none and page < current_page
      })

    if opens_on_current_page or chapters.len() == 0 {
      none
    } else {
      let chapter = chapters.last()
      let prefix = heading_outline_prefix(chapter)
      align(right)[
        #text(size: 9pt, font: body_fonts, weight: "regular")[#prefix.]
        #h(0.08em)
        #text(size: 12pt, font: body_fonts, weight: "regular")[#smallcaps(chapter.body)]
      ]
      v(running_header_rule_gap)
      line(length: 100%, stroke: 0.45pt)
    }
  }
}

#let thesis_bibliography(path, title: [Bibliography], style: none) = [
  #pagebreak()
  #set page(header: none)
  #if style == none {
    bibliography(path, title: title)
  } else {
    bibliography(path, title: title, style: style)
  }
]

#let appendix(title, body) = [
  #pagebreak()
  #set page(
    margin: body_page_margin,
    header: body_running_header(),
    header-ascent: 12pt,
    numbering: "1",
    number-align: bottom + right,
    footer-descent: body_footer_descent,
  )
  #set heading(numbering: "A.1.1")
  #counter(heading).update(0)
  #heading(level: 1)[#title]
  #body
]

#let contents_top_level_spacing = 20pt
#let contents_entry_spacing = 6pt

#let top_level_outline_entry(prefix, body, page, prefix-width: 0.7em) = block(above: contents_top_level_spacing)[
  #set par(justify: false)
  #if prefix == none {
    grid(
      columns: (1fr, auto),
      column-gutter: 0.7em,
      [#text(weight: "bold")[#body #box(width: 1fr, outline_fill)]], align(bottom)[#page],
    )
  } else {
    grid(
      columns: (prefix-width, 1fr, auto),
      column-gutter: 0.7em,
      text(weight: "bold")[#prefix],
      [
        #text(weight: "bold")[
          #body
          #box(width: 1fr, outline_fill)
        ]
      ],
      align(bottom)[#page],
    )
  }
]

#let nested_outline_entry(indent, prefix, body, page, prefix-width: 1.8em) = block(above: contents_entry_spacing)[
  #set par(justify: false)
  #grid(
    columns: (indent, prefix-width, 1fr, auto),
    column-gutter: (0pt, 0.7em, 0.7em),
    [],
    if prefix == none { [] } else { [#prefix] },
    [
      #body
      #box(width: 1fr, outline_fill)
    ],
    align(bottom)[#page],
  )
]

#let contents_page(title) = [
  #set page(
    margin: body_page_margin,
    numbering: "i",
    number-align: bottom + right,
    footer-descent: body_footer_descent,
  )
  #set par(first-line-indent: 0pt)
  #front_title(title)
  #v(2mm)
  #context {
    let entries = query(heading.where(outlined: true)).filter(entry => entry.level <= 3)

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
          nested_outline_entry(1.2em, prefix, entry.body, page),
        )
      } else {
        link(
          entry.location(),
          nested_outline_entry(3.7em, prefix, entry.body, page),
        )
      }
    }
  }
]

#let listing_page(title, kind) = [
  #set page(
    margin: body_page_margin,
    numbering: "i",
    number-align: bottom + right,
    footer-descent: body_footer_descent,
  )
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
      v(4pt)
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
  set text(font: body_fonts, size: body_font_size)
  set par(
    first-line-indent: 1.5em,
    justify: true,
    leading: body_leading,
    spacing: 6pt,
  )
  set heading(numbering: "1.1.1")
  set outline(indent: auto)
  set figure(gap: figure_caption_gap)
  show heading.where(level: 1): it => [
    #pagebreak(weak: true)
    #counter(figure.where(kind: image)).update(0)
    #counter(figure.where(kind: table)).update(0)
    #block(
      above: 0pt,
      below: 26pt,
      text(font: body_fonts, size: 18pt, weight: "bold", tracking: -0.3pt)[
        #if it.numbering == none {
          it.body
        } else {
          [#counter(heading).display(it.numbering) #h(0.2em) #it.body]
        }
      ],
    )
  ]
  show heading.where(level: 2): it => block(
    above: 46pt,
    below: 22pt,
    text(font: body_fonts, size: 14pt, weight: "bold", tracking: 0.2pt)[
      #counter(heading).display(it.numbering) #h(0.45em) #it.body
    ],
  )
  show heading.where(level: 3): it => block(
    above: 22pt,
    below: 14pt,
    text(font: body_fonts, size: 12pt, weight: "bold")[
      #counter(heading).display(it.numbering) #h(0.3em) #it.body
    ],
  )
  show heading.where(level: 4): it => block(
    above: 22pt,
    below: 14pt,
    it.body,
  )
  show figure: it => block(
    above: figure_spacing_above,
    below: figure_spacing_below,
    it,
  )
  show figure.caption: it => text(font: body_fonts, size: 12pt)[
    #strong[#figure_caption_prefix(it.kind):] #it.body
  ]
  show math.equation.where(block: true): it => block(
    above: equation_spacing_above,
    below: equation_spacing_below,
    it,
  )
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
    #set page(
      margin: body_page_margin,
      header: body_running_header(),
      header-ascent: 12pt,
      numbering: "1",
      number-align: bottom + right,
      footer-descent: body_footer_descent,
    )
    #counter(page).update(1)
    #doc
  ]
}
