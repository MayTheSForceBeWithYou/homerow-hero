-- Drill 04. The range worth memorising: this line and the next two, without ever
-- looking at a line number. The cursor starts on line 2.
return {
  goal = 'Replace "a" with X on the current line and the next two',
  hint = 'One address is the current line; the other is relative to it.',
  start = { 'one a', 'two a', 'three a', 'four a', 'five a' },
  cursor = { 2, 0 },
  want = { 'one a', 'two X', 'three X', 'four X', 'five a' },
  keys = '', -- <- your answer
}
