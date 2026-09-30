-- Drill 01. `.` repeats the last change. Delete three words using one delete and
-- two repeats.
return {
  goal = 'Delete the first three words using dw once and . twice',
  start = { 'a b c d e' },
  cursor = { 1, 0 },
  want = { 'd e' },
  keys = 'dw..',
}
