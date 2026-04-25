# Masaryk University Thesis Typst Template

> Work in progress: this template is still being ported and visually aligned.

This project is a Typst port of the Masaryk University thesis template from the
`fithesis4` LaTeX template. The goal is to provide a Typst template that follows
the Faculty of Informatics thesis layout while keeping the source easier to edit
and maintain.

## Installation

Install the template with:

```sh
npx typst-dl https://github.com/JosefKuchar/muni-thesis-typst
```

## Usage

The main example lives in `example/main.typ` and imports the template from
`lib.typ`.

Compile the example with:

```sh
typst compile --root . --font-path ./fonts example/main.typ example/output.pdf
```

The `--font-path ./fonts` flag is important so Typst uses the bundled fonts
instead of substituting system fonts.

## Project Structure

- `lib.typ` - main template logic
- `example/main.typ` - example thesis document
- `template/` - packaged Typst template entrypoint
- `assets/` - logos and visual assets
- `fonts/` - bundled fonts used by the template
- `tex-rendered.pdf` - rendered LaTeX reference used for visual comparison
- `scripts/` - helper scripts for compiling and comparing outputs

## Reference

The visual reference is the already rendered `tex-rendered.pdf`. The original
LaTeX source under `tex-source/` is useful for understanding layout choices, but
the reference PDF is the source of truth for visual alignment.
