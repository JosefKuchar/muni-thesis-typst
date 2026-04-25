#!/bin/sh
set -eu

usage() {
  cat <<'EOF'
Usage: scripts/compare-focus.sh [options]

Options:
  -p, --pages SPEC       Pages to compare, e.g. 1, 1-3, or 1,4-6. Default: 1-6
  -r, --resolution DPI   Render resolution. Default: 144
  -s, --skip-compile     Skip Typst compilation.
  -h, --help             Show this help.
EOF
}

parse_pages() {
  awk -v spec="$1" '
    BEGIN {
      n = split(spec, parts, ",")
      for (i = 1; i <= n; i++) {
        part = parts[i]
        gsub(/^[[:space:]]+|[[:space:]]+$/, "", part)
        if (part == "") {
          continue
        }
        if (part ~ /^[0-9]+-[0-9]+$/) {
          split(part, bounds, "-")
          start = bounds[1] + 0
          end = bounds[2] + 0
          if (start <= end) {
            for (page = start; page <= end; page++) {
              print page
              count++
            }
          } else {
            for (page = end; page <= start; page++) {
              print page
              count++
            }
          }
          continue
        }
        if (part ~ /^[0-9]+$/) {
          print part + 0
          count++
          continue
        }
        printf "Invalid page spec segment: '\''%s'\''.\n", part > "/dev/stderr"
        exit 2
      }
      if (count == 0) {
        printf "No pages resolved from spec '\''%s'\''.\n", spec > "/dev/stderr"
        exit 2
      }
    }
  ' | sort -n -u
}

PAGES="1-6"
RESOLUTION="144"
SKIP_COMPILE=0

while [ "$#" -gt 0 ]; do
  case "$1" in
    -p|--pages|-Pages)
      [ "$#" -ge 2 ] || { echo "Missing value for $1" >&2; exit 2; }
      PAGES=$2
      shift 2
      ;;
    -r|--resolution|-Resolution)
      [ "$#" -ge 2 ] || { echo "Missing value for $1" >&2; exit 2; }
      RESOLUTION=$2
      shift 2
      ;;
    -s|--skip-compile|-SkipCompile)
      SKIP_COMPILE=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

case "$RESOLUTION" in
  ''|*[!0-9]*)
    echo "Resolution must be a positive integer." >&2
    exit 2
    ;;
esac

PAGE_LIST=$(parse_pages "$PAGES")

if [ "$RESOLUTION" -le 0 ]; then
  echo "Resolution must be a positive integer." >&2
  exit 2
fi

SCRIPT_DIR=$(CDPATH= cd "$(dirname "$0")" && pwd -P)
TEMPLATE_DIR=$(CDPATH= cd "$SCRIPT_DIR/.." && pwd -P)

REF_PDF="$TEMPLATE_DIR/tex-rendered.pdf"
CANDIDATE_PDF="$TEMPLATE_DIR/example/output.pdf"
FOCUS_DIR="$TEMPLATE_DIR/compare/focus"
REF_DIR="$FOCUS_DIR/ref"
CAND_DIR="$FOCUS_DIR/cand"
BLEND_DIR="$FOCUS_DIR/blend"
SIDE_DIR="$FOCUS_DIR/side"

mkdir -p "$REF_DIR" "$CAND_DIR" "$BLEND_DIR" "$SIDE_DIR"

if [ "$SKIP_COMPILE" -eq 0 ]; then
  "$SCRIPT_DIR/compile-typst.sh"
fi

for page in $PAGE_LIST; do
  page_label=$(printf "%02d" "$page")
  ref_png="$REF_DIR/page-$page_label.png"
  cand_png="$CAND_DIR/page-$page_label.png"
  blend_png="$BLEND_DIR/page-$page_label.png"
  side_png="$SIDE_DIR/page-$page_label.png"
  legacy_ref_png="$REF_DIR/page-$page.png"
  legacy_cand_png="$CAND_DIR/page-$page.png"

  rm -f "$ref_png" "$cand_png" "$blend_png" "$side_png" "$legacy_ref_png" "$legacy_cand_png"

  mutool draw -F png -r "$RESOLUTION" -o "$ref_png" "$REF_PDF" "$page"
  mutool draw -F png -r "$RESOLUTION" -o "$cand_png" "$CANDIDATE_PDF" "$page"

  magick \
    '(' "$ref_png" -fuzz 8% -transparent white -fill '#0066ff' -colorize 100 ')' \
    '(' "$cand_png" -fuzz 8% -transparent white -fill '#ff0000' -colorize 100 ')' \
    -background white -compose Over -flatten \
    "$blend_png"

  magick "$ref_png" "$cand_png" +append "$side_png"
done

PAGE_LABELS=$(printf "%s\n" "$PAGE_LIST" | awk 'BEGIN { first = 1 } { if (!first) printf ", "; printf "%s", $0; first = 0 }')
printf "Compared pages %s at %sdpi.\n" "$PAGE_LABELS" "$RESOLUTION"
printf "Reference PNGs: %s\n" "$REF_DIR"
printf "Candidate PNGs: %s\n" "$CAND_DIR"
printf "Blend PNGs: %s\n" "$BLEND_DIR"
printf "Side-by-side PNGs: %s\n" "$SIDE_DIR"
