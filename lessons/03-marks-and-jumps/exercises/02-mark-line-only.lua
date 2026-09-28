-- Drill 02. Same mark, the line-addressed spelling. It lands on the line's first
-- non-blank character -- column 4 here, because the line is indented by four.
--
-- Choose a start column that makes the two spellings distinguishable: set the mark
-- at column 8, inside "gamma", so that returning by line lands earlier.
return {
  goal = 'Return to the marked line at its first non-blank, not at the marked column',
  hint = 'The other of the two spellings. Vim uses it for line addressing everywhere.',
  start = { 'alpha', 'beta', '    gamma', 'delta' },
  cursor = { 3, 8 },
  want = { 'alpha', 'beta', '    gamma', 'delta' },
  want_cursor = { 3, 4 },
  keys = '', -- <- your answer
}
