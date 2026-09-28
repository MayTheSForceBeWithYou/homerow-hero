-- Drill 02. The pairing worth naming: one keystroke to move, one to repeat. Append
-- a semicolon to all three lines without recording anything.
return {
  goal = 'Append ";" to every line using one change and then move-and-repeat',
  hint = 'A;<Esc> makes the change. What is the cheapest way to do the next line?',
  start = { 'x', 'y', 'z' },
  cursor = { 1, 0 },
  want = { 'x;', 'y;', 'z;' },
  keys = 'A;<Esc>j.j.',
}
