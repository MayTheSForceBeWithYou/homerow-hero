-- Drill 04. `:g` supplies the lines; the command does the work. Substitute, but only
-- on the lines that match.
return {
  goal = 'Replace "keep" with K only on lines containing "keep"',
  start = { 'keep 1', 'DROP a', 'keep 2', 'DROP b', 'keep 3' },
  cursor = { 1, 0 },
  want = { 'K 1', 'DROP a', 'K 2', 'DROP b', 'K 3' },
  keys = ':g/keep/s/keep/K/<CR>',
}
