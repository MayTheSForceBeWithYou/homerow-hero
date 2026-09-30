-- Drill 06. Change a word on line 2, wander to the last line, then return to where
-- you edited -- again without setting a mark yourself.
return {
  goal = 'Change "bbb" to "XXX", move to the last line, then return to the change',
  hint = 'One of the automatic marks points at the last change.',
  start = { 'aaa', 'bbb', 'ccc', 'ddd' },
  cursor = { 2, 0 },
  want = { 'aaa', 'XXX', 'ccc', 'ddd' },
  want_cursor = { 2, 0 },
  keys = '', -- <- your answer
}
