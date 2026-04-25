#import "../lib.typ": fithesis, chapter, chapter_star

#show: fithesis.with(
  title: [The Proof of #text(weight: "regular")[P = NP]],
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
    These are the acknowledgements for my thesis, which can span multiple
    paragraphs.
  ],
  abstract_body: [
    This is the abstract of my thesis, which can span multiple paragraphs.
  ],
  keywords: ("keyword1", "keyword2", "…"),
)

#chapter_star[Introduction]

Theses are rumoured to be "the capstones of education", so I decided to write
one of my own. If all goes well, I will soon have a diploma under my belt. Wish
me luck!

Rika se, ze zaverecne prace jsou "vyvrcholenim studia" a tak jsem se rozhodl
jednu take napsat. Pokud vse pujde podle planu, odnesu si na konci semestru
diplom. Drzte mi palce!

Hovori sa, ze zaverecne prace su "vyvrcholenim studia" a tak som sa rozhodol
jednu tiez napisat. Ak vsetko pojde podla planu, odnesiem si na konci semestra
diplom. Drzte mi palce!

Man munkelt, dass die Dissertation "die Kronung der Ausbildung" ist. Deshalb
habe ich mich beschlossen meine eigene zu schreiben. Wenn alles gut geht,
bekomme ich bald ein Diplom. Wunsch mir Gluck!

#chapter[Using lightweight markup]

If you decide that LaTeX is too wordy for some parts of your document, there are
tools that allow you to use lighter markup next to it.

#figure(
  image("/assets/fi-color.svg", width: 4.8cm),
  caption: [The old-style seal of the Faculty of Informatics],
)

#figure(
  kind: table,
  table(
    columns: 4,
    align: (right, left, left, center),
    table.header([Right], [Left], [Default], [Center]),
    [12], [12], [12], [12],
    [123], [123], [123], [123],
    [1], [1], [1], [1],
  ),
  caption: [This is a table with different types of alignment.],
)

#chapter[These are]
== the available
=== sectioning

Inside the text, you can also use unnumbered lists, numbered lists, quotations,
and basic semantic markup. The exact flow differs from LaTeX, but the thesis
template keeps the same page geometry and hierarchy.

#lorem(140)

#chapter[Floats and references]

#figure(
  image("/assets/base-english-color.svg", width: 6.3cm),
  caption: [The logo of the Masaryk University at 6.3 cm],
)

#figure(
  kind: table,
  table(
    columns: (auto, auto, auto, 1fr),
    table.header([Day], [Min Temp], [Max Temp], [Summary]),
    [Monday], [$13 degree C$], [$21 degree C$], [A clear day with low wind and no adverse current advisories.],
    [Tuesday], [$11 degree C$], [$17 degree C$], [A trough of low pressure will come from the northwest.],
    [Wednesday], [$10 degree C$], [$21 degree C$], [Rain will spread to all parts during the morning.],
  ),
  caption: [A weather forecast],
)

#lorem(180)

#chapter[Mathematical equations]

Inline equations such as $e^(i x) = cos x + i sin x$ and display equations such
as

$ gamma P x = P A x = P A P^(-1) P x $

#lorem(180)

#chapter[We have several fonts at disposal]

The serified roman font is used for the main body of the text. *Italics* are
typically used to denote emphasis. `Monospace` text is suited to source code.

#lorem(140)

#chapter[Inserting the bibliography]
#lorem(180)

#chapter[Inserting the index]
#lorem(180)

#chapter[An appendix]
#lorem(80)
