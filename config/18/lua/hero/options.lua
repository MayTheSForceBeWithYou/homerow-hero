-- lua/hero/options.lua
--
-- Editor options only. No keymaps -- those are in `keymaps.lua`, and the split is what
-- lets `hero/init.lua` guarantee this file runs first.

-- Leader keys -- FIRST, and not by convention.
--
-- `<leader>` is expanded when a mapping is *created*, not when the key is
-- pressed. Any mapping defined above these two lines is bound to the default
-- leader `\` instead, permanently and with no error. Check any mapping with
-- `:nmap <leader>n` -- the listing shows the leader already expanded.
-- ---------------------------------------------------------------------------
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- ---------------------------------------------------------------------------

-- Options
--
-- `vim.opt.x = v` is the Lua spelling of `:set x=v`. The difference between
-- vim.opt, vim.o, vim.bo and vim.wo is lesson 18; until then, set with vim.opt
-- and read with `:set x?` rather than reading vim.opt back.
-- ---------------------------------------------------------------------------

-- These are GLOBAL DEFAULTS: every buffer and window opened later should start from
-- them. That is exactly what `vim.opt` is for -- it writes both the global value and the
-- current local one, like `:set`.
--
-- Per-filetype settings are the other case and do NOT belong here. Setting a
-- buffer-scoped option like `shiftwidth` with `vim.opt` from a FileType autocommand would
-- change the global default too, so the next buffer of any filetype would inherit it.
-- Those go in an autocommand using `vim.bo` (lesson 24).
--
-- The discriminating question is: should a buffer opened later inherit this? Yes -> here.

-- Errors and `:help` both talk in line numbers. `number` is WINDOW-scoped, so this sets
-- the global default that new windows inherit.
vim.opt.number = true

-- Indent with spaces. Neovim's default is a literal tab, which is why `>>`
-- inserted "\t" in lesson 01's drill 15.
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

-- A pair: `ignorecase` alone would remove case-sensitive search entirely.
-- With `smartcase`, typing any capital makes that search case-sensitive again.
-- Both are GLOBAL-scoped, so there is no local/global question for them at all.
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- A LIST option, and the reason `vim.opt` returns an Option object rather than a value.
-- Assigning a Lua list is joined with commas for you, and `:append` / `:remove` splice
-- entries without your having to get the separators right by hand.
--
-- Read one of these back with `vim.opt.wildignore:get()` (a table) or `vim.o.wildignore`
-- (the raw comma string). Reading `vim.opt.wildignore` gives you the OBJECT, which is the
-- commonest mistake with this table -- `+` on it appends rather than adding.
vim.opt.wildignore = { '*.o', '*.pyc', '*.class' }

-- Show whitespace that matters. A MAP-style option: `:get()` returns key/value pairs.
vim.opt.list = true
vim.opt.listchars:append('trail:·')
vim.opt.listchars:append('nbsp:␣')

-- ---------------------------------------------------------------------------
