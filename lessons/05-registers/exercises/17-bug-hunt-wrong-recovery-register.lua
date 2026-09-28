-- Drill 17. BUG HUNT -- starts FAILING. One character is wrong.
--
-- The intent is to put back the line that was YANKED, after a delete has taken over
-- the unnamed register. The author reached for the numbered register.
--
-- Run it and read `got`: you get the deleted line, not the yanked one. Ask which
-- register a delete writes to, and which one only a yank writes to.
return {
  goal = 'After yanking line 1 and deleting line 2, put the yanked line',
  hint = 'Deletes queue in the numbered registers. Which register do they never touch?',
  start = { 'KEEP', 'GONE', 'tail' },
  cursor = { 1, 0 },
  want = { 'KEEP', 'tail', 'KEEP' },
  keys = 'yyjdd"1p',
}
