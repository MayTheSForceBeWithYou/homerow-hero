#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

mapfile -t lua_files < <(find ./0[0-9]-* -type f -name '*.lua' 2>/dev/null | sort)

for f in "${lua_files[@]}"; do
  echo "Loading ${f}"
  nvim --headless -u NONE -l "${f#./}"
done
