-- Drill 19. Before running a wide substitution, count the matches. One flag reports
-- the number and changes nothing -- verify the buffer is untouched.
return {
  goal = 'Count the matches on the line without modifying the buffer',
  hint = 'One flag makes a substitution report instead of act.',
  start = { 'a a a' },
  cursor = { 1, 0 },
  want = { 'a a a' },
  keys = '', -- <- your answer
}
