-- Drill 01. The plainest composition: one operator, one motion.
-- Delete the first word *and* the space after it.
return {
  goal = 'Delete "the" and the space following it',
  hint = 'Which of the two word motions is exclusive?',
  start = { 'the quick brown fox' },
  cursor = { 1, 0 },
  want = { 'quick brown fox' },
  keys = '', -- <- your answer
}
