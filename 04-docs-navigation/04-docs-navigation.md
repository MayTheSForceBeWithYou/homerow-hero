# 04-docs-navigation — :help as an index

This lesson is intentionally short scaffolding.

## Runnable snippets

- Lua: `04-docs-navigation/lua/smoke.lua`
- Vimscript: `04-docs-navigation/vim/smoke.vim`

## Why this exists

Vim's documentation is a giant tagged hypertext system. If you can query it
(`:h`, `getcompletion(..., 'help')`, `:helpgrep`), you never have to memorize
the API — you can derive it, which is the actual skill.

## Exercises (help-driven)

1. Run `:h vim.bo` and follow one tag link to a buffer option you have never
   used. What does it do?
2. Use `:helpgrep` to find every help mention of `LspAttach`, then step
   through the matches with `:cnext`.
3. Explain the difference between `:h`, `:h!`, and searching with `/` inside
   a help buffer.
