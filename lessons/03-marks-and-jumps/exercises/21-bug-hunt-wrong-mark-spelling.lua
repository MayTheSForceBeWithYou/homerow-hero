-- Drill 21. BUG HUNT -- starts FAILING. One character is wrong.
--
-- The intent is to delete whole lines: everything from line 1 down to and including
-- the marked line 3. Run it and look at what came back -- the remains of two lines
-- have been spliced together, because the operation went charwise instead of
-- linewise.
--
-- Both mark spellings are legal here and neither errors. They differ in *kind*.
return {
  goal = 'Delete whole lines 1 through 3 using the mark',
  hint = 'One spelling addresses a position; the other addresses a line.',
  start = { 'aaa', 'bbb', 'ccc', 'ddd' },
  cursor = { 3, 1 },
  want = { 'ddd' },
  keys = 'magg0ld`a',
}
