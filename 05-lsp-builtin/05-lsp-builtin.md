# 05-lsp-builtin — Neovim 0.12's built-in LSP client

This lesson is intentionally short scaffolding. It will grow into
`vim.lsp.config` / `vim.lsp.enable`, `LspAttach` keymaps, completion, and
diagnostics later.

## Runnable snippets

- Lua: `05-lsp-builtin/lua/smoke.lua`
- Vimscript: `05-lsp-builtin/vim/smoke.vim`

## Why this exists

0.12-era Neovim configures language servers without nvim-lspconfig. The smoke
test pins the entry points (`vim.lsp.config`, `vim.lsp.enable`) so CI catches
renames on nightly before you do.

## Nightly drift, documented live

On 2026-09-27 this repo's own CI caught a real API change: `vim.lsp.config`
was a plain function on 0.11/0.12, but on 0.13-dev nightly it became a
*callable table* — calling it still works, and you can now also read configs
back via `vim.lsp.config.<name>`. The test in `tests/05-lsp-builtin.lua`
asserts callability rather than `type(x) == 'function'` for exactly this
reason: pin the capability, not the implementation detail.

## Exercises (help-driven)

1. Read `:h vim.lsp.config` and write a config for `clangd` with a
   `root_markers` entry. (You do not need clangd installed — registration
   must not error.)
2. Find `:h LspAttach` and sketch the autocommand that sets buffer-local LSP
   keymaps.
3. Compare `:h vim.lsp.enable` with the old nvim-lspconfig setup flow — what
   disappeared?
