-- Drill 22. The other way to use the same range, and the proof that it comes from
-- marks rather than from Visual mode being active.
--
-- Select two lines, LEAVE Visual mode, then type the range explicitly. It still
-- works, because `'<` and `'>` persist after the selection ends.
return {
  goal = 'Select lines 2 and 3, leave Visual mode, then substitute on that range',
  hint = 'Here you DO type the range, because : is no longer prefilling it.',
  start = { 'one a', 'two a', 'three a', 'four a', 'five a' },
  cursor = { 2, 0 },
  want = { 'one a', 'two X', 'three X', 'four a', 'five a' },
  keys = '', -- <- your answer
}
