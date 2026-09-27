#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

shopt -s nullglob
test_files=(tests/*.lua)
shopt -u nullglob

if [[ ${#test_files[@]} -eq 0 ]]; then
  echo 'No test scripts found under tests/*.lua' >&2
  exit 1
fi

for f in "${test_files[@]}"; do
  echo "Running ${f}"
  nvim --headless -u NONE -l "$f"
done
