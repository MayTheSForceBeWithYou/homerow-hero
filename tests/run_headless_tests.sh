#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

for f in tests/*.lua; do
  echo "Running ${f}"
  nvim --headless -u NONE -l "$f"
done
