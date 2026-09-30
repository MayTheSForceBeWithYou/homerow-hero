-- Drill 06. `:g` and the substitution have two independent patterns -- but an EMPTY
-- substitution pattern reuses the last search, which is the one :g just used.
--
-- Uppercase "foo" on every line containing it, without typing foo twice.
return {
  goal = 'Replace foo with BAR on matching lines, writing the pattern only once',
  hint = 'Leave the substitution pattern empty.',
  start = { 'foo one', 'bare', 'foo two' },
  cursor = { 1, 0 },
  want = { 'BAR one', 'bare', 'BAR two' },
  keys = '', -- <- your answer
}
