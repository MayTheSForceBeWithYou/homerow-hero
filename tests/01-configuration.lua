local this_file = debug.getinfo(1, 'S').source:sub(2)
local repo_root = vim.fn.fnamemodify(this_file, ':p:h:h')

vim.cmd.source(repo_root .. '/01-configuration/vim/smoke.vim')
dofile(repo_root .. '/01-configuration/lua/smoke.lua')

assert(vim.g.homerow_hero_configuration_vim_loaded == 1, 'vimscript smoke file did not execute')
assert(vim.g.homerow_hero_configuration_loaded == true, 'lua smoke file did not execute')

-- Lesson 01's whole point: each option landed in the scope we aimed at.
assert(vim.bo.shiftwidth == 4, 'buffer-local shiftwidth was not applied')
assert(vim.wo.number == true, 'window-local number was not applied')
assert(vim.o.termguicolors == true, 'global termguicolors was not applied')

vim.cmd('qa!')
