local this_file = debug.getinfo(1, 'S').source:sub(2)
local repo_root = vim.fn.fnamemodify(this_file, ':p:h:h')

vim.cmd.source(repo_root .. '/02-vimscript/vim/smoke.vim')
dofile(repo_root .. '/02-vimscript/lua/smoke.lua')

assert(vim.g.homerow_hero_vimscript_loaded == 1, 'vimscript smoke file did not execute')
assert(vim.g.homerow_hero_vimscript_lua_loaded == true, 'lua smoke file did not execute')

-- Script-local function ran at source time.
assert(vim.g.homerow_hero_doubled == 42, 's:Double(21) should be 42')

-- Global Vimscript functions are callable from Lua via vim.fn.
assert(vim.fn.HomerowHeroTriple(14) == 42, 'HomerowHeroTriple(14) should be 42')

-- Buffer-scoped Vimscript variables surface through vim.b.
assert(vim.b.homerow_hero_buf_flag == 'buffer-scope', 'b: variable not visible via vim.b')

vim.cmd('qa!')
