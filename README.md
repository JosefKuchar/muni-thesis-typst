# FI MUNI Thesis Typst Template

Typst port of
[`fithesis4` for the Faculty of Informatics at Masaryk University](https://www.overleaf.com/latex/templates/fithesis4-for-the-faculty-of-informatics-at-the-masaryk-university-in-brno/qmrtczzjvpfv).

## Installation

```sh
npx typst-dl https://github.com/JosefKuchar/muni-thesis-typst
```

## Fonts

The `fonts/` directory contains the fonts used by the original LaTeX template.
Install them on your system if you want the closest visual match. Without them,
the template still works and falls back to sane default fonts.

## Usage

```typst
#import "@git/fi-muni-thesis:1.0.0": fithesis, thesis_bibliography

#show: fithesis.with(
  title: [Example Thesis Title],
  author: [Jane Student],
  advisor: [doc. John Advisor, Ph.D.],
  department: [Department of Computer Systems and Communications],
  faculty_name: [Faculty of Informatics],
  thesis_type: [Master's Thesis],
  place: "Brno",
  semester: "Spring 2026",
  declaration_body: [
    Hereby I declare that this thesis is my original work and that all sources
    used are properly cited.
  ],
  thanks_body: [
    I would like to thank my advisor for guidance and feedback.
  ],
  abstract_body: [
    This thesis studies a selected topic in computer science and presents the
    design, implementation, and evaluation of the proposed solution.
  ],
  keywords: (
    "typst",
    "thesis",
    "masaryk university",
  ),
)

= Introduction

Your thesis text starts here.

#thesis_bibliography(read("references.bib", encoding: none))

#appendix[An Appendix][
  Appendix content goes here.
]
```

See `example/main.typ` for a complete example.
