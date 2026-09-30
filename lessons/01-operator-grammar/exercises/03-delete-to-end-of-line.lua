-- Drill 03. Delete from the cursor to the end of the line, inclusive.
return {
  goal = 'Delete from "brown" to the end of the line',
  start = { 'the quick brown fox' },
  cursor = { 1, 10 },
  want = { 'the quick ' },
  keys = '', -- <- your answer
}
