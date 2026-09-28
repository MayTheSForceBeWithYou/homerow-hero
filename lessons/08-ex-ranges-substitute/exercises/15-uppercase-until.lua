-- Drill 15. The other case escape uppercases everything that follows, rather than a
-- single character. Uppercase only the first word.
return {
  goal = 'Uppercase the first word entirely, leaving the second alone',
  start = { 'abc def' },
  cursor = { 1, 0 },
  want = { 'ABC def' },
  keys = '', -- <- your answer
}
