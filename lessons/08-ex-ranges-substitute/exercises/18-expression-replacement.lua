-- Drill 18. The replacement can be computed rather than typed.
return {
  goal = 'Replace "x" with the computed result of 2+3',
  hint = 'One escape in the replacement introduces an expression.',
  start = { 'x' },
  cursor = { 1, 0 },
  want = { '5' },
  keys = '', -- <- your answer
}
