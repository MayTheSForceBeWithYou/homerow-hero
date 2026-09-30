-- Drill 18. `a"` takes the quotes and the trailing whitespace with them.
return {
  goal = 'Delete the quoted string, its quotes, and the space after it',
  start = { 'say "hi there" now' },
  cursor = { 1, 0 },
  want = { 'say now' },
  keys = '', -- <- your answer
}
