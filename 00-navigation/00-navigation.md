# 00-navigation — survival motions + first keymap→function wiring

This lesson is intentionally short scaffolding. We will later expand into high-density drills and failure-mode analysis.

## Runnable snippets

- Lua: `00-navigation/lua/smoke.lua`
- Vimscript: `00-navigation/vim/smoke.vim`

## Why this exists

Before plugin architecture or API details, you need deterministic keyboard
control over text objects and operators. You also need the core skill this
curriculum builds on: wiring a keymap directly to your own function in both
Lua and Vimscript.

## Exercises (help-driven)

1. In Lua, trace how `<leader>hh` is connected via `vim.keymap.set()` to a Lua
   function (`:h vim.keymap.set`).
2. In Vimscript, trace how `<leader>hv` is connected via `:nnoremap` to a
   Vimscript function (`:h :nnoremap`, `:h :call`).
3. Find the exact help tags for operator-pending mode and text objects. Start
   from `:h index` and record both tags.
4. Use `:helpgrep` to find where `iw` (inner word) is described, then jump to
   that location.
