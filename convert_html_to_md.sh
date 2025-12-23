#!/usr/bin/env bash
# Batch-convert a folder of .html/.htm files to Markdown using Pandoc.
# Usage:
#   ./convert_html_to_md.sh /path/to/html_folder [output_folder]
# Notes:
# - Keeps directory structure.
# - Extracts images/media to output_folder/media/
# - Produces GitHub‑flavored Markdown (.md).

set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <input_dir> [output_dir]" >&2
  exit 1
fi

IN_DIR="$(cd "$1" && pwd)"
OUT_DIR="${2:-md_out}"
OUT_DIR="$(mkdir -p "$OUT_DIR" && cd "$OUT_DIR" && pwd)"

# Verify pandoc exists
if ! command -v pandoc >/dev/null 2>&1; then
  echo "Error: pandoc is not installed. Install it first (e.g., 'brew install pandoc' or 'sudo apt-get install pandoc')." >&2
  exit 2
fi

# Normalize path without trailing slash
shopt -s dotglob nullglob

echo "Input : $IN_DIR"
echo "Output: $OUT_DIR"
echo "Converting..."

while IFS= read -r -d '' FILE; do
  REL="${FILE#"$IN_DIR"/}"
  STEM="${REL%.*}"
  MD_OUT="$OUT_DIR/$STEM.md"
  MD_DIR="$(dirname "$MD_OUT")"
  mkdir -p "$MD_DIR"

  # Extract media into a shared media folder (preserves filenames)
  MEDIA_DIR="$OUT_DIR/media"

  pandoc     --from=html-native_divs-native_spans     --to=gfm     --wrap=none     --markdown-headings=setext     --extract-media="$MEDIA_DIR"     --standalone     -o "$MD_OUT"     "$FILE"

  echo "✓ $REL -> ${MD_OUT#$OUT_DIR/}"
done < <(find "$IN_DIR" -type f \( -iname '*.html' -o -iname '*.htm' \) -print0)

echo "Done. Markdown files are in: $OUT_DIR"
echo "Images (if any) are in:      $OUT_DIR/media/"
