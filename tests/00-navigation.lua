local this_file = debug.getinfo(1, 'S').source:sub(2)
local repo_root = vim.fn.fnamemodify(this_file, ':p:h:h')

vim.cmd.source(repo_root .. '/00-navigation/vim/smoke.vim')
dofile(repo_root .. '/00-navigation/lua/smoke.lua')

assert(vim.g.homerow_hero_navigation_vim_loaded == 1, 'vimscript smoke file did not execute')
assert(vim.g.homerow_hero_navigation_loaded == true, 'lua smoke file did not execute')

-- Match on desc: nvim_get_keymap expands <leader> in lhs (to '\' by default),
-- so comparing against the literal '<leader>hh' never matches.
local maps = vim.api.nvim_get_keymap('n')
local lua_map_found = false
for _, m in ipairs(maps) do
  if m.desc == 'homerow hero lua keymap to function' then
    lua_map_found = true
    break
  end
end
assert(lua_map_found, 'expected the Lua smoke keymap to exist')

assert(
  vim.g.homerow_hero_navigation_lua_calls == nil,
  'test setup broken: Lua call counter should start empty'
)
assert(
  vim.g.homerow_hero_navigation_vim_calls == nil,
  'test setup broken: Vim call counter should start empty'
)

local lhs_lua = vim.api.nvim_replace_termcodes('<leader>hh', true, false, true)
local lhs_vim = vim.api.nvim_replace_termcodes('<leader>hv', true, false, true)
vim.fn.feedkeys(lhs_lua .. lhs_vim, 'x')

assert(vim.g.homerow_hero_navigation_lua_calls == 1, 'Lua keymap did not call its function')
assert(vim.g.homerow_hero_navigation_vim_calls == 1, 'Vimscript keymap did not call its function')

vim.cmd('qa!')
