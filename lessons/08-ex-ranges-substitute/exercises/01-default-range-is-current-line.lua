-- Drill 01. The range defaults to the current line. Substitute on line 3 only,
-- leaving every other line alone.
return {
  goal = 'Replace "a" with X on the current line only',
  start = { 'one a', 'two a', 'three a', 'four a', 'five a' },
  cursor = { 3, 0 },
  want = { 'one a', 'two a', 'three X', 'four a', 'five a' },
  keys = '', -- <- your answer
}
