#!/bin/sh
set -eu

usage() {
  cat <<'EOF'
Usage: scripts/compile-typst.sh [options]

Options:
  -i, --input PATH       Typst input path. Default: example/main.typ
  -o, --output PATH      PDF output path. Default: example/output.pdf
  -f, --font-path PATH   Font path passed to Typst. Default: fonts
  -h, --help             Show this help.
EOF
}

INPUT_PATH="example/main.typ"
OUTPUT_PATH="example/output.pdf"
FONT_PATH="fonts"

while [ "$#" -gt 0 ]; do
  case "$1" in
    -i|--input|--input-path|-InputPath)
      [ "$#" -ge 2 ] || { echo "Missing value for $1" >&2; exit 2; }
      INPUT_PATH=$2
      shift 2
      ;;
    -o|--output|--output-path|-OutputPath)
      [ "$#" -ge 2 ] || { echo "Missing value for $1" >&2; exit 2; }
      OUTPUT_PATH=$2
      shift 2
      ;;
    -f|--font-path|-FontPath)
      [ "$#" -ge 2 ] || { echo "Missing value for $1" >&2; exit 2; }
      FONT_PATH=$2
      shift 2
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

SCRIPT_DIR=$(CDPATH= cd "$(dirname "$0")" && pwd -P)
TEMPLATE_DIR=$(CDPATH= cd "$SCRIPT_DIR/.." && pwd -P)

cd "$TEMPLATE_DIR"
typst compile --root . --font-path "$FONT_PATH" "$INPUT_PATH" "$OUTPUT_PATH"
