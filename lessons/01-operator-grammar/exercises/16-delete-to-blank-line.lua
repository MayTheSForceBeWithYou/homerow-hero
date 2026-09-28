-- Drill 16. `}` moves to the next blank line and is exclusive and charwise.
-- The blank line therefore survives, and so does everything after it.
return {
  goal = 'Delete the first paragraph but leave the blank line',
  start = { 'p1a', 'p1b', '', 'p2a' },
  cursor = { 1, 0 },
  want = { '', 'p2a' },
  keys = '', -- <- your answer
}
