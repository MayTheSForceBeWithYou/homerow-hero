# 00-navigation — survival motions, operators, text objects

This lesson is intentionally short scaffolding. We will later expand into high-density drills and failure-mode analysis.

## Runnable snippets

- Lua: `00-navigation/lua/smoke.lua`
- Vimscript: `00-navigation/vim/smoke.vim`

## Why this exists

Before plugin architecture or API details, you need deterministic keyboard control over text objects and operators. The capstone workflow assumes this baseline.

## Exercises (help-driven)

1. Find the exact help tags for operator-pending mode and text objects. Start from `:h index` and record both tags.
2. Use `:helpgrep` to find where `iw` (inner word) is described, then jump to that location.
3. Find help for repeating the last change and identify the difference between `.` and `@:`.
