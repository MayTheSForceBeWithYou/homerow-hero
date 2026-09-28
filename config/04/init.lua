-- ~/.config/hero/init.lua
--
-- The practice config for homerow-hero, reached with:
--   NVIM_APPNAME=hero nvim
--
-- One file for now. Lesson 27 splits it into modules, and there is a reason to
-- wait: the ordering constraints below are much easier to see while everything
-- is visible at once.

-- ---------------------------------------------------------------------------
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
-- Keymaps
--
-- `vim.keymap.set(mode, lhs, rhs, opts)`. Non-recursive by default -- the Lua
-- equivalent of :nnoremap -- which is why `:nmap` shows a `*` beside it.
--
-- Always set `desc`: it is what `:nmap` prints and how you find a mapping again
-- months later. Binding a key to a function you wrote is lesson 23.
-- ---------------------------------------------------------------------------

-- The `<CR>` is required. Without it the command is typed onto the command line
-- and left there, unexecuted.
vim.keymap.set('n', '<leader>n', ':nohlsearch<CR>', { desc = 'Clear search highlight' })

-- ---------------------------------------------------------------------------
-- Last line. Neovim reports an error and then carries on starting, so a usable
-- editor is not evidence this file ran. `:lua = vim.g.hero_config_loaded` is.
-- ---------------------------------------------------------------------------
vim.g.hero_config_loaded = true
