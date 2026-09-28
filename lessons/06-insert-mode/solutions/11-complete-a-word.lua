-- Drill 11. Built-in completion, no plugin. The long word is already in the buffer,
-- so finish the partial one from it.
return {
  goal = 'Complete "al" into "alphabetical" using the word already in the buffer',
  hint = "Neovim searches the buffers listed in 'complete' -- one key starts it.",
  start = { 'alphabetical', 'al' },
  cursor = { 2, 1 },
  want = { 'alphabetical', 'alphabetical' },
  keys = 'A<C-n><Esc>',
}
