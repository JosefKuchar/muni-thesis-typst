# TeX PDF to Typst Iteration Workflow

There is a rendered TeX reference in tex-rendered.pdf and the Typst template lives at the repository root.
Do not render the TeX source.
Compile the Typst output, render both PDFs to PNGs with MuPDF, create blend and side-by-side comparisons with ImageMagick, inspect the first few pages, and iteratively adjust the Typst source toward the TeX reference.
Focus on template pages first before body content.
Store comparison assets under compare/focus.
Prefer the bundled shell or PowerShell scripts over manually repeating the full command sequence.

## Goal

Use the already rendered TeX PDF as the visual reference and iteratively move the Typst source toward it.
Use tex source as secondary reference to understand margins, font sizes, colors and other details, but do not render it directly.

## Source of Truth

- Reference PDF: `tex-rendered.pdf`
- TeX source directory: `tex-source`
- Typst template directory: repository root
- Main Typst example: `example/main.typ`
- Main Typst template logic: `lib.typ`

## Hard Rules

- Do **not** render the TeX source.
- Use `tex-rendered.pdf` as the reference.
- Render PDF pages to PNG with MuPDF (`mutool`).
- Build visual blends and side-by-side comparisons with ImageMagick (`magick`).
- Edit only the Typst source when iterating.
- Prefer `scripts/compile-typst.sh` / `scripts/compare-focus.sh` on Unix-like systems, or `scripts/compile-typst.ps1` / `scripts/compare-focus.ps1` on PowerShell systems, for the standard workflow.
- Do **not** run `compare-focus.sh`, `compare-focus.ps1`, `compile-typst.sh`, or `compile-typst.ps1` concurrently with each other or other scripts that read or write the same Typst PDF or comparison asset directories.
- When one of those scripts is running, any other such script must wait until it finishes. Treat the workflow as serialized to avoid data races and partially refreshed comparison assets.

## Recommended Directory Layout for Comparisons

Use this structure inside `compare/focus`:

- `ref/` for PNGs rendered from `tex-rendered.pdf`
- `cand/` for PNGs rendered from the Typst PDF
- `blend/` for blended overlays
- `side/` for side-by-side comparisons

## Typical Iteration Loop

1. Compile the Typst output.
2. Render the relevant pages from `tex-rendered.pdf` to `ref/`.
3. Render the same pages from the Typst PDF to `cand/`.
4. Generate:
   - a blended overlay image for each page
   - a side-by-side image for each page
5. Inspect the first pages visually.
6. Edit `lib.typ` or the example Typst source.
7. Repeat until the layout converges.

## Preferred Commands

Use these scripts from the repo root unless there is a specific reason not to.

Run these scripts one at a time. Do not start another compile, render, or compare script until the current one has finished writing its outputs.

### 1. Compile Typst

Unix-like shell:

```sh
./scripts/compile-typst.sh
```

PowerShell:

```powershell
.\scripts\compile-typst.ps1
```

### 2. Compile and Build Focus Comparisons

For the first template pages:

```sh
./scripts/compare-focus.sh --pages 1-6
```

```powershell
.\scripts\compare-focus.ps1 -Pages 1-6
```

For a single page:

```sh
./scripts/compare-focus.sh --pages 1
```

```powershell
.\scripts\compare-focus.ps1 -Pages 1
```

If the PDF is already current and only the comparison assets need regeneration:

```sh
./scripts/compare-focus.sh --pages 1-3 --skip-compile
```

```powershell
.\scripts\compare-focus.ps1 -Pages 1-3 -SkipCompile
```

The compare script:

- compiles the Typst example unless `-SkipCompile` is passed
- renders requested pages one-by-one so filenames stay stable as `page-01.png`, `page-02.png`, etc.
- refreshes `ref/`, `cand/`, `blend/`, and `side/` assets only for the requested pages
- color-codes blend overlays so the reference image is blue and the Typst candidate is red

## Manual Fallback Commands

### 1. Compile Typst

Run from the repo root:

```powershell
typst compile --root . --font-path .\fonts .\example\main.typ .\example\output.pdf
```

The `--font-path .\fonts` flag is important. Without it, Typst may substitute fonts and invalidate the visual comparison.

### 2. Create Comparison Directories

Run from repo root:

```powershell
$dirs = 'compare\focus\ref',
        'compare\focus\cand',
        'compare\focus\blend',
        'compare\focus\side'
foreach ($d in $dirs) { New-Item -ItemType Directory -Force -Path $d | Out-Null }
```

### 3. Render Reference PDF Pages with MuPDF

Example for pages 1 to 6:

```powershell
mutool draw -F png -r 144 -o "compare\focus\ref\page-%02d.png" tex-rendered.pdf 1-6
```

### 4. Render Typst PDF Pages with MuPDF

```powershell
mutool draw -F png -r 144 -o "compare\focus\cand\page-%02d.png" "example\output.pdf" 1-6
```

### 5. Build Overlay and Side-by-Side Images with ImageMagick

For blend images, color-code the reference image in blue and the Typst candidate in red.

```powershell
1..6 | ForEach-Object {
  $n = '{0:d2}' -f $_
  magick "(" "compare\focus\ref\page-$n.png" `
             -fuzz 8% -transparent white `
             -fill "#0066ff" -colorize 100 ")" `
         "(" "compare\focus\cand\page-$n.png" `
             -fuzz 8% -transparent white `
             -fill red -colorize 100 ")" `
         -background white -compose Over -flatten `
         "compare\focus\blend\page-$n.png"

  magick "compare\focus\ref\page-$n.png" `
         "compare\focus\cand\page-$n.png" `
         +append `
         "compare\focus\side\page-$n.png"
}
```

## What to Inspect First

Start with the template pages before worrying about body content:

- cover
- title page
- seal page
- declaration
- acknowledgements
- abstract / keywords

If page count differs heavily between the reference and Typst outputs, do not spend time on small spacing tweaks yet. Fix the document structure first.

## Practical Heuristics

### If the Typst output has fewer pages than the reference

Usually one of these is true:

- content is missing
- front matter is laid out differently
- page breaks do not match
- margins or font metrics differ enough to collapse pages

### If overlays look wrong even when spacing seems close

Check:

- font loading
- image asset choice
- page numbering mode
- page margins
- whether the heading is inline instead of block-level

### For front matter pages

Prefer matching:

- page sequencing
- major vertical rhythm
- left vs centered composition
- title block size and spacing
- footer / page-number behavior

before refining paragraph micro-spacing.

## Suggested Session Strategy

### Template alignment

Only compare the first few pages and ignore the body content.

Good page ranges:

- `1-3` for cover, title, seal
- `4-6` for declaration, acknowledgements, abstract/keywords

## Typical Files to Edit

- `lib.typ`
  - shared page builders
  - margins
  - heading definitions
  - front matter layout
- `example/main.typ`
  - example content
  - page sequencing
  - structural coverage
