-- lua/hero/init.lua
--
-- This file exists to name the LOAD ORDER, and that is its whole job.
--
-- `options` must run before `keymaps`, because `<leader>` is expanded when a mapping is
-- created rather than when it is pressed (lesson 04) -- so `vim.g.mapleader` has to be
-- set before any `vim.keymap.set` call runs. In a single file that was the order of two
-- lines. Split across modules it is the order of two `require` calls, and having one
-- file state it is better than leaving it implicit in `init.lua`.
--
-- Add a module by adding a line here, in the position its dependencies require.

require('hero.options')
require('hero.keymaps')
