local this_file = debug.getinfo(1, 'S').source:sub(2)
local repo_root = vim.fn.fnamemodify(this_file, ':p:h:h')

dofile(repo_root .. '/05-lsp-builtin/lua/smoke.lua')
vim.cmd.source(repo_root .. '/05-lsp-builtin/vim/smoke.vim')

assert(vim.g.homerow_hero_lsp_builtin_loaded == true, 'lua smoke file did not execute')
assert(vim.g.homerow_hero_lsp_builtin_vim_loaded == 1, 'vimscript smoke file did not execute')

-- Nightly canary: the 0.12 built-in LSP entry points must exist.
assert(type(vim.lsp.config) == 'function', 'vim.lsp.config missing - nightly API drift?')
assert(type(vim.lsp.enable) == 'function', 'vim.lsp.enable missing - nightly API drift?')

-- Registering a config must not error, even with no server binary installed.
vim.lsp.config('homerow_hero_fake', {
  cmd = { 'definitely-not-a-real-lsp-server' },
  root_markers = { '.git' },
})

vim.cmd('qa!')
