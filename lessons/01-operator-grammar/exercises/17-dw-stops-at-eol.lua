-- Drill 17. Two boundary facts in one drill.
--
-- First: `dw` on the last word of a line does *not* pull the next line up. The
-- motion would normally cross the line break; under an operator it stops at the
-- end of the line instead.
--
-- Second, and easy to miss: the space *before* "fox" survives. The cursor starts
-- on the `f`, and an operator only ever affects text from the cursor onward -- so
-- `want` below ends with a trailing space. Look closely at it.
return {
  goal = 'Delete the last word of line 1 without joining line 2 onto it',
  hint = 'The result has a trailing space. Why would the operator not reach it?',
  start = { 'the quick brown fox', 'next line' },
  cursor = { 1, 16 },
  want = { 'the quick brown ', 'next line' },
  keys = '', -- <- your answer
}
