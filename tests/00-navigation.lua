local this_file = debug.getinfo(1, 'S').source:sub(2)
local repo_root = vim.fn.fnamemodify(this_file, ':p:h:h')

vim.cmd.source(repo_root .. '/00-navigation/vim/smoke.vim')
dofile(repo_root .. '/00-navigation/lua/smoke.lua')

assert(vim.g.homerow_hero_navigation_vim_loaded == 1, 'vimscript smoke file did not execute')
assert(vim.g.homerow_hero_navigation_loaded == true, 'lua smoke file did not execute')

-- Match on desc: nvim_get_keymap expands <leader> in lhs (to '\' by default),
-- so comparing against the literal '<leader>hh' never matches.
local maps = vim.api.nvim_get_keymap('n')
local found = false
for _, m in ipairs(maps) do
  if m.desc == 'homerow hero smoke map' then
    found = true
    break
  end
end
assert(found, 'expected the smoke keymap to exist')

vim.cmd('qa!')
