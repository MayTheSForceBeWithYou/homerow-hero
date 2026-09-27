# 02-vimscript — scopes, functions, evaluation model

This lesson is intentionally short scaffolding. It will grow into deep
Vimscript coverage later.

## Runnable snippets

- Lua: `02-vimscript/lua/smoke.lua`
- Vimscript: `02-vimscript/vim/smoke.vim`

## Why this exists

You will read Vimscript for years (plugins, legacy configs). You need its
scope prefixes cold — `g:` `b:` `w:` `s:` `l:` `a:` — and you need to know how
Lua sees them through `vim.g`, `vim.b`, and `vim.fn`.

## Exercises (help-driven)

1. Find the help tag documenting internal variable scopes
   (`:h internal-variables`) and list what each prefix means.
2. Explain why `s:Double` cannot be called from Lua via `vim.fn`, but
   `HomerowHeroTriple` can. Find the help that says so.
3. Use `:helpgrep` to find how function arguments arrive
   (`a:0`, `a:1`, `a:000`).
