-- Drill 03. `.` repeats the change, and a text object makes the change
-- position-independent -- so `w.` works from anywhere in the next word.
return {
  goal = 'Replace the first two words with Z using ciw once and then move-and-repeat',
  start = { 'aa bb cc' },
  cursor = { 1, 0 },
  want = { 'Z Z cc' },
  keys = '', -- <- your answer
}
