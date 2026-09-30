return {
  goal = 'Replace every "a" on every line',
  hint = 'Two independent ideas. You have supplied one of them.',
  start = { 'a a', 'a a', 'a a' },
  cursor = { 1, 0 },
  want = { 'X X', 'X X', 'X X' },
  -- `%` chose the lines and did its job. `g` chooses the matches within each line;
  -- without it a substitution replaces only the first match per line. The two are
  -- independent, and conflating them is the commonest substitution mistake.
  keys = ':%s/a/X/g<CR>',
}
