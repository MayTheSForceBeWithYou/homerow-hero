-- Drill 04. The other direction. A motion may move backwards; the operator still
-- applies to the text between the two positions.
return {
  goal = 'Delete from the cursor back to column 1',
  start = { 'the quick brown fox' },
  cursor = { 1, 10 },
  want = { 'brown fox' },
  keys = '', -- <- your answer
}
