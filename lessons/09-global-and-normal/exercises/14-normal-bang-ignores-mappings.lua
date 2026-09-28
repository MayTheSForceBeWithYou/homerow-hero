-- Drill 14. `setup` maps X to something destructive. `:normal` obeys mappings;
-- `:normal!` does not. Run the BUILT-IN X, not the mapping.
--
-- The built-in X deletes the character before the cursor, so from column 2 it removes
-- the first character.
return {
  goal = 'Run the built-in X, not the mapping, deleting the character before the cursor',
  hint = 'One character makes an Ex command ignore mappings.',
  start = { 'word one' },
  cursor = { 1, 1 },
  want = { 'ord one' },
  setup = function()
    vim.keymap.set('n', 'X', 'ciwMAPPED<Esc>', { desc = 'drill 14 trap' })
  end,
  keys = '', -- <- your answer
}
