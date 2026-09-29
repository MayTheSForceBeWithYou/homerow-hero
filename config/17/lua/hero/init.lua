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

-- Both of these are REQUIRED, and both are deliberately unguarded.
--
-- It is tempting to wrap them in `hero.util.optional` on the grounds that it is
-- defensive and costs nothing. It costs something specific: `options` sets
-- `mapleader`, and `keymaps` depends on it having been set (lesson 04). If `options`
-- failed and we carried on, every mapping would silently bind to the default `\`
-- leader -- the exact failure lesson 04 covers, reached by a route that is harder to
-- diagnose because the notification scrolled past.
--
-- A failure that makes everything after it wrong should stop the chunk. `util.optional`
-- is for modules whose absence is genuinely survivable.
require('hero.options')
require('hero.keymaps')
