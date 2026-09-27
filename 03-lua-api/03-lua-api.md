# 03-lua-api — the vim.* modules and the buffer object model

This lesson is intentionally short scaffolding. It will grow into full
`vim.api` / `vim.fn` / `vim.bo` coverage later.

## Runnable snippets

- Lua: `03-lua-api/lua/smoke.lua`
- Vimscript: `03-lua-api/vim/smoke.vim`

## Why this exists

This is the lesson the whole repo was built for: answering "which buffer am I
in, what kind is it, and has it changed?" The `should_save` predicate in the
smoke snippet is the exact guard the capstone uses before compiling.

## Exercises (help-driven)

1. Open `:h vim.bo` and find the `modified` and `buftype` entries. What other
   `buftype` values exist besides `''`?
2. Compare `:h buftype` with `:h 'filetype'` — why does the capstone guard on
   `buftype` and not `filetype`?
3. Find `:h nvim_buf_get_option()` and explain when you would use it instead
   of `vim.bo[bufnr]`.
