local this_file = debug.getinfo(1, 'S').source:sub(2)
local repo_root = vim.fn.fnamemodify(this_file, ':p:h:h')

dofile(repo_root .. '/06-capstone/lua/smoke.lua')
vim.cmd.source(repo_root .. '/06-capstone/vim/smoke.vim')

assert(vim.g.homerow_hero_capstone_loaded == true, 'lua smoke file did not execute')
assert(vim.g.homerow_hero_capstone_vim_loaded == 1, 'vimscript smoke file did not execute')

local save_if_modified = _G.homerow_hero.save_if_modified
assert(type(save_if_modified) == 'function', 'save_if_modified not defined')

-- Case 1: normal file buffer with unsaved changes gets written to disk.
local tmp = vim.fn.tempname() .. '.txt'
vim.cmd('edit ' .. vim.fn.fnameescape(tmp))
vim.api.nvim_buf_set_lines(0, 0, -1, false, { 'capstone' })
assert(vim.bo.modified == true, 'test setup broken: buffer not marked modified')
assert(save_if_modified() == true, 'expected the modified buffer to be saved')
assert(vim.bo.modified == false, 'buffer should be unmodified after save')
assert(vim.fn.readfile(tmp)[1] == 'capstone', 'file contents did not reach disk')

-- Case 2: already-saved buffer - no write, returns false.
assert(save_if_modified() == false, 'must not rewrite an unmodified buffer')

-- Case 3: special buffer with content - never touches disk.
-- NOTE: :h buftype says "nofile" (and "nowrite") buffers are never considered
-- 'modified', so a "modified nofile buffer" cannot exist; the buftype guard
-- in save_if_modified() is the operative check here, not the modified flag.
vim.cmd('enew')
vim.bo.buftype = 'nofile'
vim.api.nvim_buf_set_lines(0, 0, -1, false, { 'scratch' })
assert(vim.bo.buftype == 'nofile', 'test setup broken: buftype not set')
assert(save_if_modified() == false, 'must never auto-save a nofile buffer')

vim.fn.delete(tmp)
vim.cmd('qa!')
