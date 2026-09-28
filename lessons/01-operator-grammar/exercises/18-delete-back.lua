-- Drill 18. `b` moves back a word and is exclusive. Delete the word before the
-- cursor, leaving the cursor's own word intact.
return {
  goal = 'Delete "brown " leaving "fox"',
  start = { 'the quick brown fox' },
  cursor = { 1, 16 },
  want = { 'the quick fox' },
  keys = '', -- <- your answer
}
