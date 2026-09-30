-- Drill 08. `:m` moves lines. Gather all the DROP lines at the bottom, in order.
return {
  goal = 'Move every DROP line to the end of the file',
  hint = 'The move command takes a destination address.',
  start = { 'keep 1', 'DROP a', 'keep 2', 'DROP b', 'keep 3' },
  cursor = { 1, 0 },
  want = { 'keep 1', 'keep 2', 'keep 3', 'DROP a', 'DROP b' },
  keys = ':g/DROP/m$<CR>',
}
