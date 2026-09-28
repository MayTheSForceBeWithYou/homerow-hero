#!/usr/bin/env bash
# tools/check-exercises-unsolved.sh -- guard against drills that check nothing.
#
# Every exercise ships with its answer blanked (or, for a BUG HUNT, wrong). So a
# fresh checkout must report zero PASS across all exercises. A PASS here means
# the drill would pass without the learner doing anything -- exactly the
# "test that cannot fail" failure this repo was rebuilt to remove (DESIGN.md §7).
#
# Run from a clean checkout. It will report a false positive if you have filled
# in answers locally, which is why CI is where it is authoritative.
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

shopt -s nullglob
dirs=(lessons/*/exercises)
shopt -u nullglob
[[ ${#dirs[@]} -gt 0 ]] || { echo "no exercises found" >&2; exit 1; }

# `./drill` exits nonzero when anything FAILs, which is expected here (bug hunts),
# so read the report rather than the exit status.
report="$(./drill "${dirs[@]}" 2>/dev/null)" || true

passing="$(grep -c 'PASS' <<<"$report" || true)"

if [[ "$passing" -ne 0 ]]; then
  echo "$report" | grep 'PASS'
  echo
  echo "check-exercises-unsolved: ${passing} exercise drill(s) pass with no answer filled in." >&2
  echo "Either an answer was committed by mistake, or the drill does not check anything." >&2
  exit 1
fi

echo "$report" | tail -3
echo "check-exercises-unsolved: no exercise passes unattempted."
