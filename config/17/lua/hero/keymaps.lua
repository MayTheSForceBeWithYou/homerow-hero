-- lua/hero/keymaps.lua
--
-- Keymaps only. This module relies on `hero.options` having already run, because the
-- leader key must exist before any mapping is created. `hero/init.lua` guarantees that
-- ordering; nothing here enforces it, which is worth knowing if you ever require this
-- module directly.

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

-- Leave a modified buffer without writing it. Without this, switching files with
-- unsaved changes raises E37 -- which is obstructive once you are in the habit of
-- saving. The cost is that unsaved buffers accumulate where you cannot see them, so
-- `:ls` (look for `+` in the last flag column) and `:wa` are the counterweight.
vim.opt.hidden = true

-- Window navigation without the <C-w> prefix. The prefix is fine for the commands
-- you use occasionally; moving between splits is not occasional.
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Window left' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Window down' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Window up' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Window right' })

-- Buffers. `:b` takes a substring, so <leader>b lists them and leaves the cursor on
-- a `:buffer ` command line ready for a few characters of a filename -- which is
-- faster than remembering numbers.
vim.keymap.set('n', '<leader>b', ':ls<CR>:buffer ', { desc = 'List buffers and pick one' })

-- The cheapest navigation in the editor: flip between the two files you are actually
-- working on. The `#` in a `:ls` listing shows where it will go.
vim.keymap.set('n', '<leader><leader>', '<C-^>', { desc = 'Toggle to the alternate buffer' })

-- Search behaviour. `incsearch` shows matches as you type; `hlsearch` keeps them
-- highlighted afterwards, which is what <leader>n (above) clears.
vim.opt.incsearch = true
vim.opt.hlsearch = true

-- Quickfix navigation. `:cnext` and `:cprevious` are used constantly and are far too
-- long to type, so they are the first thing worth mapping.
--
-- `[q` and `]q` follow the built-in convention from `:h ]` -- `[` for backwards and
-- `]` for forwards over a list -- which is why the diagnostic maps below use the same
-- shape.
vim.keymap.set('n', ']q', ':cnext<CR>', { desc = 'Next quickfix entry' })
vim.keymap.set('n', '[q', ':cprevious<CR>', { desc = 'Previous quickfix entry' })
vim.keymap.set('n', '<leader>q', ':copen<CR>', { desc = 'Open the quickfix list' })
vim.keymap.set('n', '<leader>Q', ':cclose<CR>', { desc = 'Close the quickfix list' })

-- The location-list twins. Separate mappings because the two lists are separate
-- things: one quickfix list for the session, one location list per window.
vim.keymap.set('n', ']l', ':lnext<CR>', { desc = 'Next location-list entry' })
vim.keymap.set('n', '[l', ':lprevious<CR>', { desc = 'Previous location-list entry' })

-- ---------------------------------------------------------------------------
