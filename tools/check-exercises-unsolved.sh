#!/usr/bin/env bash
# tools/check-exercises-unsolved.sh -- guard against drills that check nothing.
#
# Every exercise ships with its answer blanked (or, for a BUG HUNT, wrong). So a
# fresh checkout must satisfy two things:
#
#   1. zero PASS. A PASS means the drill would pass without the learner doing
#      anything -- the "test that cannot fail" failure this repo was rebuilt to
#      remove (DESIGN.md §7).
#   2. every NON-bug-hunt exercise reports TODO rather than FAIL. An unattempted
#      drill must not look broken. A FAIL here almost always means the answer was
#      marked with an ANSWER_BEGIN block when it is a *statement* whose effect the
#      check asserts on -- so blanking it left the check running against untouched
#      setup. Use the line form plus a -- TODO_GUARD instead (AUTHORING.md).
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

# A FAIL is expected only for a BUG HUNT, which ships a deliberately wrong answer.
mapfile -t bad_fails < <(grep 'FAIL' <<<"$report" | grep -v 'bug-hunt' || true)
if [[ ${#bad_fails[@]} -ne 0 ]]; then
  printf '%s\n' "${bad_fails[@]}"
  echo
  echo "check-exercises-unsolved: ${#bad_fails[@]} non-bug-hunt exercise(s) report FAIL rather than TODO." >&2
  echo "An unattempted drill must not look broken. This is usually a statement answer" >&2
  echo "marked with an ANSWER_BEGIN block; use the line form plus -- TODO_GUARD instead." >&2
  exit 1
fi

echo "$report" | tail -3
echo "check-exercises-unsolved: no exercise passes unattempted."
