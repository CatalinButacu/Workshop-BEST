#!/usr/bin/env bash
# build.sh -- Compileaza prezentarea Beamer (sharescreen).
# Output: main.pdf in directorul curent.
# Ruleaza pdflatex de doua ori (pentru cuprins / cross-refs).

set -e
set -u

if ! command -v pdflatex >/dev/null 2>&1; then
  echo "ERROR: pdflatex not found. Install MiKTeX or TeX Live."
  exit 1
fi

START=$(date +%s)
echo "Compiling main.tex..."

if pdflatex -interaction=nonstopmode -halt-on-error main.tex > /dev/null 2>&1 \
&& pdflatex -interaction=nonstopmode -halt-on-error main.tex > /dev/null 2>&1; then
  rm -f main.aux main.log main.nav main.out main.snm main.toc main.synctex.gz
  ELAPSED=$(( $(date +%s) - START ))
  echo "Done in ${ELAPSED}s -> main.pdf"
  ls -la main.pdf 2>/dev/null | awk '{printf "  %s bytes\n", $5}'
else
  echo "FAILED -- see main.log for details."
  exit 1
fi
