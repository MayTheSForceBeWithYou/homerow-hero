-- Drill 16. `\zs` sets where the match begins, so the text before it is required
-- context rather than something to replace. Replace only "bar", but only when it
-- follows "foo".
return {
  goal = 'Replace only "bar" with X, requiring "foo" before it',
  hint = 'One escape moves the start of the match without capturing anything.',
  start = { 'foobar' },
  cursor = { 1, 0 },
  want = { 'fooX' },
  keys = '', -- <- your answer
}
