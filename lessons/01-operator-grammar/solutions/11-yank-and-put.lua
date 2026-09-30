-- Drill 11. `y` is an operator like any other, and `p` puts what it captured.
-- Duplicate the first line below itself.
return {
  goal = 'Duplicate the first line',
  hint = 'Yank linewise, then put.',
  start = { 'copy me', 'other' },
  cursor = { 1, 0 },
  want = { 'copy me', 'copy me', 'other' },
  keys = 'yyp',
}
