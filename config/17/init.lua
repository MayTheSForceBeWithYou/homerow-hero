-- ~/.config/hero/init.lua
--
-- The entry point, and now almost nothing. Everything real lives under `lua/hero/`,
-- which `require` finds because `~/.config/hero` is the first entry on the runtimepath
-- and `require('hero')` looks for `lua/hero.lua` or `lua/hero/init.lua` inside it.
--
-- Two things to know about this arrangement, both from lesson 16:
--
--   * `require` runs a file ONCE per session and caches the result, so `:source %` here
--     re-runs this file while every module below it stays cached. A real restart is the
--     authoritative reload now.
--   * the `hero` directory is namespacing. `require('options')` could collide with any
--     plugin shipping `lua/options.lua`; `require('hero.options')` cannot.

require('hero')

-- Neovim reports an error and then carries on starting, so a usable editor is not
-- evidence this file ran. `:lua = vim.g.hero_config_loaded` is.
vim.g.hero_config_loaded = true
