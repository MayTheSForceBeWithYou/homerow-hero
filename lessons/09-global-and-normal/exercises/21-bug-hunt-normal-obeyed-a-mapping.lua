-- Drill 21. BUG HUNT -- starts FAILING. One character is missing.
--
-- The intent is to run the BUILT-IN X, which deletes the character before the cursor.
-- But `setup` has mapped X to something destructive -- as a user's config or an
-- earlier line of your own might -- and the command obeyed the mapping instead.
--
-- This is why a script must never write this command the way it is written here.
return {
  goal = 'Run the built-in X rather than the mapping, deleting the character before the cursor',
  hint = 'One character makes an Ex command ignore mappings entirely.',
  start = { 'word one' },
  cursor = { 1, 1 },
  want = { 'ord one' },
  setup = function()
    vim.keymap.set('n', 'X', 'ciwMAPPED<Esc>', { desc = 'drill 21 trap' })
  end,
  keys = ':normal X<CR>',
}
