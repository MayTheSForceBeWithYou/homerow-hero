-- Drill 03. A mark is a motion, so it composes with operators. The line-addressed
-- spelling makes the operation LINEWISE: whole lines 1 through 3 go.
return {
  goal = 'From line 1, delete every line up to and including the marked line 3',
  start = { 'aaa', 'bbb', 'ccc', 'ddd' },
  cursor = { 3, 1 },
  want = { 'ddd' },
  keys = "maggd'a",
}
