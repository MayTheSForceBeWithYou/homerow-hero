-- Drill 12. The expression register computes rather than stores. From Insert mode,
-- open a line below and insert the result of 2+3 without typing the digit 5.
return {
  goal = 'Open a line below and insert the computed result of 2+3',
  hint = 'One Insert-mode key reaches a register; one register evaluates.',
  start = { 'x' },
  cursor = { 1, 0 },
  want = { 'x', '5' },
  keys = '', -- <- your answer
}
