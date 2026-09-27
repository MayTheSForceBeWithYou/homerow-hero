-- Lesson 05: the built-in LSP client surface (Neovim 0.12 / nightly).
-- Pin the entry points here so CI fails fast on nightly API renames.
local M = {}

M.has_config = type(vim.lsp.config) == 'function'
M.has_enable = type(vim.lsp.enable) == 'function'

vim.g.homerow_hero_lsp_builtin_loaded = true

return M
