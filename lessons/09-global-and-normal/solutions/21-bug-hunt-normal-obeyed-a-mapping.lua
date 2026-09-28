return {
  goal = 'Run the built-in X rather than the mapping, deleting the character before the cursor',
  hint = 'One character makes an Ex command ignore mappings entirely.',
  start = { 'word one' },
  cursor = { 1, 1 },
  want = { 'ord one' },
  setup = function()
    vim.keymap.set('n', 'X', 'ciwMAPPED<Esc>', { desc = 'drill 21 trap' })
  end,
  -- `:normal` obeys mappings, so it ran the trap. `:normal!` runs the built-in
  -- commands. Always write the bang in a config or a script, or your code changes
  -- behaviour depending on what the user has mapped.
  keys = ':normal! X<CR>',
}
