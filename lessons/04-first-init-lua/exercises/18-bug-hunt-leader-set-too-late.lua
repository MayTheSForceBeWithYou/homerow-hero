-- Drill 18. BUG HUNT -- starts FAILING, and this is the single most common way a
-- real config wastes an evening.
--
-- The intent is that pressing `,u` uppercases the word under the cursor. The
-- mapping looks right and nothing errors. Run it: the buffer comes back unchanged.
--
-- Look at the ORDER of the two lines in `setup`. The lesson states the rule in one
-- sentence, and `:nmap` would show you the evidence in a real Neovim.
return {
  goal = 'Make ,u uppercase the word under the cursor',
  hint = 'When is <leader> expanded -- at set time, or at press time?',
  start = { 'make this loud' },
  cursor = { 1, 5 },
  want = { 'make THIS loud' },
  setup = function()
    vim.keymap.set('n', '<leader>u', 'gUiw', { desc = 'drill 18 uppercase word' })
    vim.g.mapleader = ','
  end,
  keys = ',u',
}
