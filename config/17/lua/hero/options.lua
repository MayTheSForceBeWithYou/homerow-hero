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

-- Errors and `:help` both talk in line numbers.
vim.opt.number = true

-- Indent with spaces. Neovim's default is a literal tab, which is why `>>`
-- inserted "\t" in lesson 01's drill 15.
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

-- A pair: `ignorecase` alone would remove case-sensitive search entirely.
-- With `smartcase`, typing any capital makes that search case-sensitive again.
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- ---------------------------------------------------------------------------
