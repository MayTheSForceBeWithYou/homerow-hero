-- Drill 05. `f` searches forward on this line and is inclusive: it takes the
-- character it finds. Delete up to and including the first `o`.
return {
  goal = 'Delete through the first "o" on the line',
  start = { 'the quick brown fox' },
  cursor = { 1, 0 },
  want = { 'wn fox' },
  keys = 'dfo',
}
