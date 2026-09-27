# 01-configuration — init files, load order, option scopes

This lesson is intentionally short scaffolding. It will grow into the full
init.lua / lazy.nvim module later.

## Runnable snippets

- Lua: `01-configuration/lua/smoke.lua`
- Vimscript: `01-configuration/vim/smoke.vim`

## Why this exists

Everything downstream (keymaps, autocmds, LSP) depends on knowing *where* an
option lives: `vim.bo` (buffer), `vim.wo` (window), `vim.o` (global). Get the
scope wrong and the setting silently applies to the wrong thing.

## Exercises (help-driven)

1. Find the help tag that lists every option with its scope (`:h option-list`)
   and identify one global, one buffer-local, and one window-local option.
2. From `:h vim.opt`, explain the difference between `vim.opt`, `vim.o`,
   `vim.bo`, and `vim.wo`.
3. After the smoke snippets load, run `:verbose set shiftwidth?` and explain
   where the value came from.
