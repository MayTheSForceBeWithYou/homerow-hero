-- Drill 02. One character of difference from drill 01, and it addresses the whole
-- file. `%` is an address, not a wildcard -- it is shorthand for 1,$
return {
  goal = 'Replace "a" with X on every line in the file',
  start = { 'one a', 'two a', 'three a', 'four a', 'five a' },
  cursor = { 3, 0 },
  want = { 'one X', 'two X', 'three X', 'four X', 'five X' },
  keys = '', -- <- your answer
}
