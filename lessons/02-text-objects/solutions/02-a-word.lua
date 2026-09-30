-- Drill 02. Same cursor, the other size. Take the word and close the gap.
return {
  goal = 'Delete "brown" and its trailing space',
  hint = 'The other half of the i/a pair.',
  start = { 'the quick brown fox' },
  cursor = { 1, 11 },
  want = { 'the quick fox' },
  keys = 'daw',
}
