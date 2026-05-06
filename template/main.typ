#import "@preview/fi-muni-thesis:1.0.0": fithesis, chapter, chapter_star

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
Replace this file with the contents of your thesis.
