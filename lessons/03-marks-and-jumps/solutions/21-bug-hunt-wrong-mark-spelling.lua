return {
  goal = 'Delete whole lines 1 through 3 using the mark',
  hint = 'One spelling addresses a position; the other addresses a line.',
  start = { 'aaa', 'bbb', 'ccc', 'ddd' },
  cursor = { 3, 1 },
  want = { 'ddd' },
  -- The backtick spelling addresses a *position*, so the delete ran charwise from
  -- the cursor to the mark's column and joined the remains into "acc". The
  -- apostrophe spelling addresses a *line*, which makes the operator linewise.
  -- The extra `0l` positioning is no longer needed either, since a linewise
  -- operation ignores the column.
  keys = "maggd'a",
}
