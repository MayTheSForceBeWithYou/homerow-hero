# 06-capstone — save-before-compile for MSVC cl.exe

This lesson is intentionally short scaffolding. It will grow into async
`cl.exe` invocation with quickfix integration later.

## Runnable snippets

- Lua: `06-capstone/lua/smoke.lua`
- Vimscript: `06-capstone/vim/smoke.vim`

## Why this exists

The motivating workflow: one keymap that saves the current file — but only
when it is a normal file buffer with unsaved changes — before compiling.
`save_if_modified()` is that keymap's core; the test proves it against real
buffers, including a real file on disk.

## Exercises (help-driven)

1. Extend `save_if_modified` to also skip buffers whose `filetype` is in a
   denylist (e.g. `qf`, `help`). Write the test first.
2. Find `:h :write` and `:h ++p` — how would you preserve file permissions
   or encoding on save?
3. Sketch the next step: running `cl.exe` via `vim.system()` and feeding
   errors to the quickfix list (`:h vim.system`, `:h quickfix`).
