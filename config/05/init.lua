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

-- System clipboard, opt-in per operation.
--
-- The alternative is `vim.opt.clipboard = 'unnamedplus'`, which makes the unnamed
-- register *be* the system clipboard so that plain `y` and `p` talk to it. That is
-- genuinely convenient, and it has one cost worth understanding before choosing
-- it: every *delete* then overwrites your system clipboard too. Copy a URL in the
-- browser, `dd` a line here, and the URL is gone.
--
-- These mappings keep the clipboard as something you ask for. `<leader>y` and
-- `<leader>p` in both Normal and Visual mode, so a visual selection works the same
-- way. To switch to the other decision instead, delete these four lines and
-- uncomment the option above them.
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y', { desc = 'Yank to system clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p', { desc = 'Put from system clipboard' })

-- Yank the whole line to the clipboard. `"+Y` would yank to end-of-line, which is
-- rarely what is meant, so this spells out the linewise form.
vim.keymap.set('n', '<leader>Y', '"+yy', { desc = 'Yank line to system clipboard' })

-- Recover a yank after a delete has taken over the unnamed register. `"0` holds
-- the most recent yank and no delete ever writes to it.
vim.keymap.set('n', '<leader>0', '"0p', { desc = 'Put the last yank (not the last delete)' })

-- ---------------------------------------------------------------------------
-- Last line. Neovim reports an error and then carries on starting, so a usable
-- editor is not evidence this file ran. `:lua = vim.g.hero_config_loaded` is.
-- ---------------------------------------------------------------------------
vim.g.hero_config_loaded = true
