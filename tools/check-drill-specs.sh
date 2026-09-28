#!/usr/bin/env bash
# Verify every exercise poses the same problem as its solution. See the Lua file.
set -uo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
nvim --headless -u NONE -l tools/check-drill-specs.lua 2>/dev/null
