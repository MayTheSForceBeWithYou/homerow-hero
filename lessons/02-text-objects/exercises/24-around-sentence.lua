-- Drill 24. Sentences split on . ! or ? followed by whitespace. `as` takes the
-- sentence and its separator; `is` would leave a double space behind.
return {
  goal = 'Delete the middle sentence cleanly, leaving a single space',
  start = { 'One. Two. Three.' },
  cursor = { 1, 6 },
  want = { 'One. Three.' },
  keys = '', -- <- your answer
}
