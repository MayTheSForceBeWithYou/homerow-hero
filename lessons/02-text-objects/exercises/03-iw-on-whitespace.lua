-- Drill 03. The cursor is on the SPACE before "brown", not on a word at all.
-- `iw` means "inner word *or* whitespace run" -- so it has a target here.
-- Delete just that space, joining the two words.
return {
  goal = 'From the space before "brown", delete only the space',
  hint = 'You do not need a different object than drill 01.',
  start = { 'the quick brown fox' },
  cursor = { 1, 9 },
  want = { 'the quickbrown fox' },
  keys = '', -- <- your answer
}
