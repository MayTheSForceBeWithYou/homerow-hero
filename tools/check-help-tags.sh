#!/usr/bin/env bash
# tools/check-help-tags.sh -- verify every :help tag cited in a lesson resolves.
#
# DESIGN.md §6 requires that every tag a lesson cites actually exists. A lesson
# that sends the reader to a nonexistent tag is worse than one that sends them
# nowhere, so this runs in CI.
#
# Scans every LESSON.md and TASK.md for `:h <tag>` / `:help <tag>` inside
# backticks, then asks Neovim to open each one.
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

shopt -s nullglob
files=(lessons/*/LESSON.md lessons/*/TASK.md appendices/*.md)
shopt -u nullglob

if [[ ${#files[@]} -eq 0 ]]; then
  echo "check-help-tags: no lesson files found" >&2
  exit 1
fi

# Collect tags. A citation looks like `:h foo` or `:help 'bar'` inside backticks.
# grep -o gives one match per line; strip the backticks and the :h/:help prefix.
mapfile -t tags < <(
  grep -ohE '`:h(elp)? [^`]+`' "${files[@]}" \
    | sed -E "s/^\`:h(elp)? //; s/\`$//" \
    | sed -E 's/[[:space:]]+$//' \
    | sort -u
)

if [[ ${#tags[@]} -eq 0 ]]; then
  echo "check-help-tags: found no tags to check (suspicious)" >&2
  exit 1
fi

fail=0
for tag in "${tags[@]}"; do
  # `help` needs the tag exactly; quoting matters for option tags like 'shiftwidth'.
  if nvim --headless -u NONE -c "help ${tag}" -c 'quitall!' >/dev/null 2>&1; then
    printf '  ok    :h %s\n' "$tag"
  else
    printf '  MISS  :h %s\n' "$tag"
    fail=1
  fi
done

echo
if [[ $fail -ne 0 ]]; then
  echo "check-help-tags: at least one cited tag does not resolve." >&2
  echo "Fix the citation, or the tag's quoting -- :h 'shiftwidth' and :h shiftwidth differ." >&2
  exit 1
fi
echo "check-help-tags: all ${#tags[@]} cited tags resolve."
