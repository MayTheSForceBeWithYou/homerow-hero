return {
  goal = 'Make ,u uppercase the word under the cursor',
  hint = 'When is <leader> expanded -- at set time, or at press time?',
  start = { 'make this loud' },
  cursor = { 1, 5 },
  want = { 'make THIS loud' },
  setup = function()
    -- `<leader>` is expanded when the mapping is *created*. With the order
    -- reversed, mapleader was still unset and the mapping bound to `\u` instead --
    -- silently, with no error, which is what makes this expensive to find.
    vim.g.mapleader = ','
    vim.keymap.set('n', '<leader>u', 'gUiw', { desc = 'drill 18 uppercase word' })
  end,
  keys = ',u',
}
