-- Drill 02. Same starting text, one character of difference in the result.
-- Delete only the word, leaving the space that followed it.
-- Note the leading space in `want` -- that is the whole point of this drill.
return {
  goal = 'Delete "the" but leave the space after it',
  hint = 'You need the inclusive word motion, not the exclusive one.',
  start = { 'the quick brown fox' },
  cursor = { 1, 0 },
  want = { ' quick brown fox' },
  keys = '', -- <- your answer
}
