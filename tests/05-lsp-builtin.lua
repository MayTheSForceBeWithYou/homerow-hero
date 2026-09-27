local this_file = debug.getinfo(1, 'S').source:sub(2)
local repo_root = vim.fn.fnamemodify(this_file, ':p:h:h')

dofile(repo_root .. '/05-lsp-builtin/lua/smoke.lua')
vim.cmd.source(repo_root .. '/05-lsp-builtin/vim/smoke.vim')

assert(vim.g.homerow_hero_lsp_builtin_loaded == true, 'lua smoke file did not execute')
assert(vim.g.homerow_hero_lsp_builtin_vim_loaded == 1, 'vimscript smoke file did not execute')

-- Nightly canary: the built-in LSP entry points must exist and be callable.
-- NOTE (real drift, caught by this test on 2026-09-27): on 0.11/0.12
-- vim.lsp.config was a plain function; on 0.13-dev it is a callable table
-- (it also supports vim.lsp.config.<name> indexing). Assert callability, not
-- a specific type, so the test tracks the API instead of snapshotting it.
local function is_callable(x)
  if type(x) == 'function' then
    return true
  end
  local mt = type(x) == 'table' and getmetatable(x)
  return mt ~= nil and type(mt.__call) == 'function'
end

assert(is_callable(vim.lsp.config), 'vim.lsp.config missing - nightly API drift?')
assert(type(vim.lsp.enable) == 'function', 'vim.lsp.enable missing - nightly API drift?')

-- Registering a config must not error, even with no server binary installed.
vim.lsp.config('homerow_hero_fake', {
  cmd = { 'definitely-not-a-real-lsp-server' },
  root_markers = { '.git' },
})

-- 0.13-dev also exposes configs via indexing; 0.11/0.12 do not.
if type(vim.lsp.config) == 'table' then
  assert(vim.lsp.config.homerow_hero_fake ~= nil, 'registered config not retrievable')
end

vim.cmd('qa!')
