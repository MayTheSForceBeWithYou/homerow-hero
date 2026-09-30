-- Drill 20. Visual mode is the other way to give an operator its extent: select
-- first, then operate. `V` selects whole lines.
return {
  goal = 'Delete the first two lines by selecting them linewise first',
  start = { 'one', 'two', 'three' },
  cursor = { 1, 0 },
  want = { 'three' },
  keys = 'Vjd',
}
