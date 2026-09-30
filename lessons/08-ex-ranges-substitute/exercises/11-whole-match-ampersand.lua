-- Drill 11. The replacement side can refer back to what was matched. Wrap the
-- matched character in brackets without retyping it.
return {
  goal = 'Wrap the matched "b" in square brackets using a backreference',
  hint = 'One character in the replacement means "the whole match".',
  start = { 'abc' },
  cursor = { 1, 0 },
  want = { 'a[b]c' },
  keys = '', -- <- your answer
}
