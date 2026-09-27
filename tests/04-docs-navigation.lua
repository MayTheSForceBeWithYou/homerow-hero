local this_file = debug.getinfo(1, 'S').source:sub(2)
local repo_root = vim.fn.fnamemodify(this_file, ':p:h:h')

dofile(repo_root .. '/04-docs-navigation/lua/smoke.lua')
vim.cmd.source(repo_root .. '/04-docs-navigation/vim/smoke.vim')

assert(vim.g.homerow_hero_docs_navigation_loaded == true, 'lua smoke file did not execute')
assert(vim.g.homerow_hero_docs_navigation_vim_loaded == 1, 'vimscript smoke file did not execute')

-- The references that motivated this repo must be discoverable via tags.
local bo_tags = _G.homerow_hero.help_tags_for('vim.bo')
assert(#bo_tags > 0, "no help tags found for 'vim.bo'")

local buftype_tags = _G.homerow_hero.help_tags_for('buftype')
assert(#buftype_tags > 0, "no help tags found for 'buftype'")

vim.cmd('qa!')
