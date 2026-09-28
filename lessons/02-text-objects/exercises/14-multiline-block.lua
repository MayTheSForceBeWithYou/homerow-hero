-- Drill 14. The payoff, and the thing no lesson-01 motion could do: the object
-- spans lines. The cursor is on the first line; the block closes on the fourth.
return {
  goal = 'Delete the table body, keeping the braces',
  start = { 'f = {', '  a = 1,', '  b = 2,', '}' },
  cursor = { 1, 4 },
  want = { 'f = {', '}' },
  keys = '', -- <- your answer
}
