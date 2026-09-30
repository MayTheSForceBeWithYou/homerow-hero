-- Drill 01. Set a mark on line 3 at the "g" of "gamma" (column 4), move away, and
-- return to the EXACT position. The buffer must not change -- `want` equals
-- `start`; the assertion that matters is `want_cursor`.
return {
  goal = 'Set a mark at line 3 column 4, move to line 1, and return to the exact position',
  hint = 'Two commands: one to set, one to return. The precise-looking character.',
  start = { 'alpha', 'beta', '    gamma', 'delta' },
  cursor = { 3, 4 },
  want = { 'alpha', 'beta', '    gamma', 'delta' },
  want_cursor = { 3, 4 },
  keys = '', -- <- your answer
}
