-- Drill 07. Since :g covers the whole file by default, a range is how you make it do
-- LESS. Restrict it to the first three lines.
return {
  goal = 'Delete lines containing "keep" in the first three lines only',
  start = { 'keep 1', 'DROP a', 'keep 2', 'DROP b', 'keep 3' },
  cursor = { 1, 0 },
  want = { 'DROP a', 'DROP b', 'keep 3' },
  keys = ':1,3g/keep/d<CR>',
}
