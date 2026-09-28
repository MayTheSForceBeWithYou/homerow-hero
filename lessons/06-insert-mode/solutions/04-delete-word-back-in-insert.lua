-- Drill 04. You are mid-insertion and the last word is wrong. Fix it without
-- leaving Insert mode and without pressing backspace repeatedly.
return {
  goal = 'While inserting, delete the word just typed and replace it',
  hint = 'One key deletes a word backwards from inside Insert mode.',
  start = { 'x' },
  cursor = { 1, 0 },
  want = { 'hello worldx' },
  keys = 'ihello wrold<C-w>world<Esc>',
}
