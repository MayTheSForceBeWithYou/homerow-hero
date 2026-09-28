-- Drill 02. Same three keystrokes to begin with, then recover. Put the text you
-- YANKED rather than the text you deleted.
--
-- One register holds the most recent yank and is never written to by a delete.
return {
  goal = 'After yanking line 1 and deleting line 2, put the yanked line',
  hint = 'Name the register that only yanks write to.',
  start = { 'KEEP', 'GONE', 'tail' },
  cursor = { 1, 0 },
  want = { 'KEEP', 'tail', 'KEEP' },
  keys = '', -- <- your answer
}
