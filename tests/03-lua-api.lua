local this_file = debug.getinfo(1, 'S').source:sub(2)
local repo_root = vim.fn.fnamemodify(this_file, ':p:h:h')

dofile(repo_root .. '/03-lua-api/lua/smoke.lua')
vim.cmd.source(repo_root .. '/03-lua-api/vim/smoke.vim')

assert(vim.g.homerow_hero_lua_api_loaded == true, 'lua smoke file did not execute')
assert(vim.g.homerow_hero_lua_api_vim_loaded == 1, 'vimscript smoke file did not execute')

local should_save = _G.homerow_hero.should_save
assert(type(should_save) == 'function', 'should_save not defined')

-- Normal buffer, unmodified: nothing to save.
local normal = vim.api.nvim_create_buf(true, false)
assert(should_save(normal) == false, 'unmodified normal buffer must not save')

-- Normal buffer, modified: save.
vim.api.nvim_buf_set_lines(normal, 0, -1, false, { 'hello' })
assert(vim.bo[normal].modified == true, 'test setup broken: buffer not marked modified')
assert(should_save(normal) == true, 'modified normal buffer must save')

-- Special buffer (terminal/quickfix-style), modified: never auto-save.
local special = vim.api.nvim_create_buf(true, false)
vim.bo[special].buftype = 'nofile'
vim.api.nvim_buf_set_lines(special, 0, -1, false, { 'scratch' })
assert(should_save(special) == false, 'nofile buffer must never auto-save')

vim.cmd('qa!')
