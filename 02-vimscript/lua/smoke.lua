-- Lesson 02 companion: the cross-language call happens in
-- tests/02-vimscript.lua, which sources the Vimscript file first and then
-- calls back into it from here via vim.fn.
vim.g.homerow_hero_vimscript_lua_loaded = true
