-- Drill 23. `ap` takes the trailing blank line too.
return {
  goal = 'Delete the first paragraph and its trailing blank line',
  start = { 'p1a', 'p1b', '', 'p2' },
  cursor = { 1, 0 },
  want = { 'p2' },
  keys = '', -- <- your answer
}
