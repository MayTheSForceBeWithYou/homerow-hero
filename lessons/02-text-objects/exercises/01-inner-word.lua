-- Drill 01. The cursor starts mid-word -- nowhere near an edge. That is the point:
-- an object does not care. Delete just the word, leaving both spaces.
-- Note the double space in `want`.
return {
  goal = 'Delete "brown" from mid-word, leaving the spaces either side',
  start = { 'the quick brown fox' },
  cursor = { 1, 11 },
  want = { 'the quick  fox' },
  keys = '', -- <- your answer
}
