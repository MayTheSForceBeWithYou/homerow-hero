vim.cmd.source('00-navigation/vim/smoke.vim')
dofile('00-navigation/lua/smoke.lua')

assert(vim.g.homerow_hero_navigation_vim_loaded == 1, 'vimscript smoke file did not execute')
assert(vim.g.homerow_hero_navigation_loaded == true, 'lua smoke file did not execute')

local maps = vim.api.nvim_get_keymap('n')
local found = false
for _, m in ipairs(maps) do
  if m.lhs == '<leader>hh' then
    found = true
    break
  end
end
assert(found, 'expected <leader>hh map to exist')

vim.cmd('qa')
