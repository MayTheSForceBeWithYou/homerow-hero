#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

mapfile -t lua_files < <(find ./[0-9][0-9]-* -type f -name '*.lua' 2>/dev/null | sort)

if [[ ${#lua_files[@]} -eq 0 ]]; then
  echo "No lesson Lua snippets found under ./[0-9][0-9]-*/" >&2
  exit 1
fi

for f in "${lua_files[@]}"; do
  echo "Loading ${f}"
  nvim --headless -u NONE -l "${f#./}"
done
