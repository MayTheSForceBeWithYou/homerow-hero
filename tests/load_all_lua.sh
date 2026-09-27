#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

mapfile -t lua_files < <(find . -type f -name '*.lua' -not -path './.git/*' | sort)

for f in "${lua_files[@]}"; do
  echo "Loading ${f}"
  nvim --headless -u NONE "+lua dofile('${f#./}')" +qa
 done
