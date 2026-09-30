-- Drill 08. There is no motion here. Doubling the operator means "this line".
return {
  goal = 'Delete the whole first line',
  start = { 'one', 'two', 'three' },
  cursor = { 1, 0 },
  want = { 'two', 'three' },
  keys = 'dd',
}
