-- Drill 03. The other way out: delete without disturbing what you are carrying, so
-- that a plain `p` does the right thing.
return {
  goal = 'Delete line 2 without clobbering the yank, then put with a plain p',
  hint = 'One register discards whatever you write to it.',
  start = { 'KEEP', 'GONE', 'tail' },
  cursor = { 1, 0 },
  want = { 'KEEP', 'tail', 'KEEP' },
  keys = '', -- <- your answer
}
