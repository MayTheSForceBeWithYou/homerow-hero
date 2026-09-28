-- Drill 21. Tripling: operator, operator, operator. `g~` doubled is `g~~`, which
-- applies to the whole line.
return {
  goal = 'Toggle the case of every character on the line',
  start = { 'MiXeD case HERE' },
  cursor = { 1, 0 },
  want = { 'mIxEd CASE here' },
  keys = '', -- <- your answer
}
