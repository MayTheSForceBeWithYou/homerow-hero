-- Drill 13. Keep walking back. The second press reaches the older of the two
-- changes.
return {
  goal = 'Make the same two edits, then walk back two steps through the changelist',
  start = { 'l1', 'l2', 'l3', 'l4', 'l5', 'l6' },
  cursor = { 1, 0 },
  want = { 'l1', 'l2!', 'l3', 'l4', 'l5?', 'l6' },
  want_cursor = { 2, 2 },
  keys = '', -- <- your answer
}
