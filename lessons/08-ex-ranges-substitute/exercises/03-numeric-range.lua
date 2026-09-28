-- Drill 03. Two addresses separated by a comma.
return {
  goal = 'Replace "a" with X on lines 1 through 3',
  start = { 'one a', 'two a', 'three a', 'four a', 'five a' },
  cursor = { 5, 0 },
  want = { 'one X', 'two X', 'three X', 'four a', 'five a' },
  keys = '', -- <- your answer
}
