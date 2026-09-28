-- Drill 10. The most common substitution mistake is treating these as one idea.
-- `%` chooses the LINES; `g` chooses the MATCHES within each line. Use both.
return {
  goal = 'Replace every "a" on every line',
  start = { 'a a', 'a a' },
  cursor = { 1, 0 },
  want = { 'X X', 'X X' },
  keys = ':%s/a/X/g<CR>',
}
