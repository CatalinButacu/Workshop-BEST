#!/usr/bin/env bash
#
# build.sh — Compile all training handouts.
#
# - Reads .tex files from src/
# - Outputs .pdf files into pdf/ (overwriting old ones)
# - Cleans up auxiliary files (.aux, .log, .out, .toc, .synctex.gz)
# - Runs pdflatex twice per file so cross-references and outlines are right
#
# Usage:   ./build.sh           (compile everything)
#          ./build.sh 03-css    (compile a single file by basename)
#
# Requires: pdflatex (MiKTeX or TeX Live) on PATH.

set -e
set -u

SRC_DIR="src"
OUT_DIR="pdf"

# Files to compile, in display order. preamble.tex is included by these,
# not compiled directly.
# Doar main.tex (manualul complet -- 30+ pagini, un singur fisier) si
# 00-inainte.tex (standalone, distribuit cu 24h inainte de training).
FILES=(
  00-inainte
  main
)

# If user passed an argument, compile only that file.
if [ "$#" -gt 0 ]; then
  FILES=("$1")
fi

# Sanity checks
if ! command -v pdflatex >/dev/null 2>&1; then
  echo "ERROR: pdflatex not found on PATH. Install MiKTeX or TeX Live."
  exit 1
fi

if [ ! -d "$SRC_DIR" ]; then
  echo "ERROR: source folder '$SRC_DIR' not found. Run from the training/ root."
  exit 1
fi

mkdir -p "$OUT_DIR"

START_TIME=$(date +%s)
TOTAL=${#FILES[@]}
COUNT=0
FAILED=()

# Move into src/ so \input{preamble} resolves relative to the .tex files.
pushd "$SRC_DIR" > /dev/null

for f in "${FILES[@]}"; do
  COUNT=$((COUNT + 1))
  if [ ! -f "$f.tex" ]; then
    echo "[$COUNT/$TOTAL] SKIP $f.tex (not found)"
    continue
  fi
  echo "[$COUNT/$TOTAL] Compiling $f.tex ..."
  if pdflatex -interaction=nonstopmode -halt-on-error "$f.tex" > /dev/null 2>&1 \
  && pdflatex -interaction=nonstopmode -halt-on-error "$f.tex" > /dev/null 2>&1; then
    mv -f "$f.pdf" "../$OUT_DIR/"
    echo "        -> $OUT_DIR/$f.pdf"
  else
    echo "        FAILED — see $f.log for details"
    FAILED+=("$f")
  fi
done

# Clean auxiliary files left behind in src/
rm -f *.aux *.out *.toc *.synctex.gz

# Keep .log files only for failed builds (so the user can debug them).
if [ "${#FAILED[@]}" -eq 0 ]; then
  rm -f *.log
fi

popd > /dev/null

ELAPSED=$(( $(date +%s) - START_TIME ))

echo ""
echo "========================================"
if [ "${#FAILED[@]}" -eq 0 ]; then
  echo "Build complete in ${ELAPSED}s. PDFs in $OUT_DIR/"
  ls -la "$OUT_DIR"/*.pdf 2>/dev/null | awk '{printf "  %s  %s\n", $5, $NF}'
else
  echo "Build finished with ${#FAILED[@]} failure(s) in ${ELAPSED}s."
  echo "Check src/<name>.log for these:"
  for f in "${FAILED[@]}"; do
    echo "  - $f"
  done
  exit 1
fi
