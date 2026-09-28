#!/usr/bin/env bash
# tools/derive-exercises.sh -- generate a lesson's exercises/ from its solutions/.
#
#   bash tools/derive-exercises.sh 03    write lessons/03-*/exercises/
#
# This is an AUTHOR CONVENIENCE, not an invariant. An exercise may legitimately
# carry more teaching commentary than its solution, so exercises are not required
# to be byte-identical to a derivation. The invariant CI enforces is narrower and
# lives in tools/check-drill-specs.sh: an exercise and its solution must pose the
# same problem (same goal, start, cursor, want, value), differing only in the
# answer.
#
# Exercises are derived rather than written by hand so that a drill's `goal`,
# `start`, `cursor` and `want` cannot drift from the answer that satisfies them.
# Only the answer is removed.
#
# An answer is one of:
#   keys = '...'                   ->  keys = '', -- <- your answer
#   local answer = X -- <- ...     ->  local answer = nil -- <- your answer
#   return X -- <- your answer     ->  return nil -- <- your answer
#
# BUG HUNT drills are exempt: they ship a deliberately wrong answer, so they are
# authored in exercises/ by hand and skipped here. Name them *bug-hunt*.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

[[ $# -ge 1 ]] || { echo "usage: $0 <lesson-number>..." >&2; exit 2; }

warn_overwrite() {
  # Never silently clobber an exercise the learner has been filling in.
  if [[ -s "$1" ]] && grep -qE "^\s*(keys = '[^']|local answer = [^n]|return [^n].*your answer)" "$1"; then
    echo "  SKIP  $1 (looks like it holds an answer already; delete it to regenerate)"
    return 1
  fi
  return 0
}

blank() {
  sed -E \
    -e "s|^(\s*)keys = .*$|\1keys = '', -- <- your answer|" \
    -e "s|^(\s*)local answer = .*-- <- your answer$|\1local answer = nil -- <- your answer|" \
    -e "s|^(\s*)return .*-- <- your answer$|\1return nil -- <- your answer|" \
    "$1"
}

for spec in "$@"; do
  printf -v n '%02d' "$((10#$spec))"
  dir=$(compgen -G "lessons/${n}-*" | head -n1 || true)
  [[ -n "$dir" ]] || { echo "no lesson $n" >&2; exit 2; }
  [[ -d "$dir/solutions" ]] || { echo "$dir has no solutions/" >&2; exit 2; }
  mkdir -p "$dir/exercises"

  for sol in "$dir"/solutions/*.lua; do
    base="$(basename "$sol")"
    [[ "$base" == *bug-hunt* ]] && continue   # hand-authored; keeps its wrong answer
    target="$dir/exercises/$base"

    if warn_overwrite "$target"; then
      blank "$sol" > "$target"
      echo "  wrote $target"
    fi
  done
done

echo
echo "Now verify the pairs still pose the same problem:"
echo "  bash tools/check-drill-specs.sh"
