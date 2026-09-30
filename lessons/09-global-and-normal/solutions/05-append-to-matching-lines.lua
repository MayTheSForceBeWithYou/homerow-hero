-- Drill 05. A substitution anchored to end-of-line appends. Put a semicolon on every
-- DROP line and nothing else.
return {
  goal = 'Append a semicolon to every line containing DROP',
  hint = 'Substitute the end of the line for a semicolon.',
  start = { 'keep 1', 'DROP a', 'keep 2', 'DROP b' },
  cursor = { 1, 0 },
  want = { 'keep 1', 'DROP a;', 'keep 2', 'DROP b;' },
  keys = ':g/DROP/s/$/;/<CR>',
}
