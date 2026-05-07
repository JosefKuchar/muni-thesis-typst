#import "../lib.typ": fithesis, chapter, thesis_bibliography, appendix

#let lorem_a = [
  Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis posuere turpis et
  mi vestibulum lacinia. Duis ut ipsum quis nisi vehicula lobortis sed eget
  purus. Phasellus eu mi id metus fermentum ultricies. Sed mi magna, sagittis
  iaculis arcu porttitor, semper dapibus augue. Sed at turpis arcu. Maecenas
  mollis lacus mollis, pellentesque mi vel, pretium ante. Donec ligula dui,
  finibus vel molestie interdum, tempor eu orci. Vestibulum vitae metus at nulla
  suscipit eleifend eget eu felis. Sed non risus vitae dui vehicula consequat
  vel sed elit.
]

#let lorem_b = [
  Sed finibus congue nulla, ac egestas nulla maximus eu. Nullam quis ex est.
  Sed tincidunt eros sit amet commodo feugiat. Pellentesque egestas magna leo,
  in cursus orci pulvinar nec. Pellentesque efficitur mi dictum, porta metus et,
  mattis nunc. Sed ut vestibulum risus. Duis eget risus sed ligula convallis
  laoreet nec ac dui. Vivamus tincidunt nec libero et semper. Sed consectetur
  velit congue, ornare ligula at, congue ligula. Nulla vitae sem mattis, lacinia
  metus in, porttitor nunc. Praesent congue ligula dui, et vehicula enim
  faucibus vitae. Praesent ut mauris at dolor mattis ultrices.
]

#let lorem_c = [
  Mauris in justo ut nibh gravida porttitor sed ut turpis. Duis id enim ut
  lectus consequat facilisis eget id ligula. Donec vitae risus feugiat, placerat
  orci eu, tincidunt dui. Etiam ex arcu, pharetra non lectus sit amet, molestie
  dapibus urna. Sed vitae elit in metus facilisis viverra ac nec nunc. Fusce ut
  leo felis. Fusce dapibus bibendum nibh, at sodales turpis suscipit eu.
  Maecenas at ullamcorper ipsum, sit amet mollis turpis. Mauris vehicula diam ut
  felis bibendum commodo. Cras non fringilla enim. Etiam tristique, lacus quis
  venenatis sodales, quam diam porta magna, ac semper mauris quam at elit. Proin
  lacinia ipsum ut sagittis consectetur. Donec tincidunt tempus elit id dictum.
  Duis sit amet est ante. Cras sed lacinia purus, a convallis enim. Donec
  elementum pretium dignissim.
]

#let lorem_d = [
  Cras consectetur metus libero, ac feugiat urna luctus at. Curabitur pharetra
  odio vel ante mollis, ac placerat magna finibus. Vivamus sed nunc euismod,
  fermentum magna eget, hendrerit erat. Maecenas tempus ante sed dolor convallis
  cursus. Vestibulum lacinia tristique consectetur. Praesent ut leo pellentesque,
  lacinia nisl quis, condimentum ex. Vivamus vel sodales lorem, in mattis justo.
  Aliquam id sem non enim accumsan dictum ac id ante. Proin varius ex lectus,
  nec semper risus aliquet ut. Vestibulum eu nunc nulla. Aenean convallis ipsum
  a risus volutpat elementum. Vivamus in efficitur tortor, eu posuere dolor.
]

#let lorem_e = [
  Praesent ac consectetur metus. Praesent iaculis felis at lectus vestibulum
  mattis. Sed massa tortor, lacinia eget tortor nec, varius tempor risus. Fusce
  sed nisi at eros dapibus eleifend porta non dui. Lorem ipsum dolor sit amet,
  consectetur adipiscing elit. Nulla ac metus fermentum, varius ex et,
  condimentum eros. Donec id ultricies tortor, id elementum turpis. Cras semper
  viverra eros ac egestas. Vestibulum porttitor dignissim cursus. Mauris
  consectetur, lacus eget luctus ornare, ante ligula sodales ex, et ultrices
  turpis ipsum et purus. Etiam sed euismod orci. Vestibulum non arcu quis dolor
  pellentesque congue. Aliquam erat volutpat. Phasellus vulputate ligula ac
  volutpat feugiat. Suspendisse auctor egestas felis nec viverra.
]

#let long_caption = [
  A placeholder figure with long description - lorem ipsum dolor sit amet lorem
  ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet
  lorem ipsum dolor sit amet
]

#let thesis_table = figure(
  kind: table,
  supplement: none,
  caption: figure.caption(position: top)[A simple example table.],
  table(
    columns: (auto, auto, auto),
    align: (left, center, right),
    stroke: 0.45pt,
    table.header(
      [#strong[Align Left]],
      [#strong[Align Center]],
      [#strong[Align Right]],
    ),
    [Apples], [10], [\$1.50],
    [Bananas], [15], [\$2.00],
    [Cherries], [50], [\$5.75],
  ),
)

#let placeholder_figure(caption) = figure(
  supplement: none,
  rect(width: 8cm, height: 4cm, fill: black),
  caption: caption,
)

#show: fithesis.with(
  title: [The Proof of #text(weight: "regular")[$upright(P) = upright("NP")$]],
  author: [Jane Doe],
  advisor: [Prof. RNDr. John Smith, CSc.],
  department: [Department of Machine Learning and Data Processing],
  faculty_name: [Faculty of Informatics],
  thesis_type: [Bachelor's Thesis],
  place: "Brno",
  semester: "Spring 2026",
  declaration_body: [
    Hereby I declare that this paper is my original authorial work, which I have
    worked out on my own. All sources, references, and literature used or
    excerpted during elaboration of this work are properly cited and listed in
    complete reference to the due source.
  ],
  thanks_body: [
    These are the acknowledgements for my thesis, which can

    span multiple paragraphs.
  ],
  abstract_body: [
    This is the abstract of my thesis, which can

    span multiple paragraphs.
  ],
  keywords: ("keyword1", "keyword2", "..."),
)

#chapter[This is a Chapter]

First there is a citation @borgman03, and another citation @ehlinger06

#lorem_a

#lorem_b

=== This is a Subsection

Subsections divide sections into smaller, more specific topics. Here is a small
amount of text under this heading.

#heading(level: 4, numbering: none, outlined: false)[This is a Subsubsection]

This is a further division of a subsection. The text size remains standard, but
the heading itself is smaller.

#lorem_c

#lorem_d

#lorem_e

== This is a Section

#lorem_a

#lorem_b

#lorem_c

=== Adding a Table

Tables in LaTeX use the `table` environment for floating and the `tabular`
environment for the actual grid. Table 1.1 demonstrates a simple layout.

#thesis_table

#pagebreak()

=== Figures

#lorem_a

#lorem_b

#placeholder_figure[A placeholder figure (8cm wide by 4cm high).]

== Another Section

Notice how the section numbering automatically includes the chapter number
(e.g., Section 1.2).

#chapter[Another chapter]

#lorem_a

#lorem_b

#lorem_a

#lorem_b

#placeholder_figure(long_caption)

#lorem_b

See @app:example for appendix material.

#thesis_bibliography("/tex-source/example.bib")

#appendix(label: <app:example>)[An appendix][
  Here you can insert the appendices of your thesis.
]
