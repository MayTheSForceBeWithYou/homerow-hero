-- Drill 16. Square brackets, same pattern. Either delimiter of a pair names the
-- pair, so `i[` and `i]` are the same object.
return {
  goal = 'Empty the subscript, keeping the brackets',
  start = { 'arr[idx]' },
  cursor = { 1, 5 },
  want = { 'arr[]' },
  keys = '', -- <- your answer
}
