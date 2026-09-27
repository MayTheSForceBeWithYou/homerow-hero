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

## Exercises (help-driven)

1. Read `:h vim.lsp.config` and write a config for `clangd` with a
   `root_markers` entry. (You do not need clangd installed — registration
   must not error.)
2. Find `:h LspAttach` and sketch the autocommand that sets buffer-local LSP
   keymaps.
3. Compare `:h vim.lsp.enable` with the old nvim-lspconfig setup flow — what
   disappeared?
