-- Drill 13. The same substitution with very magic syntax, where the backslashes stop
-- being noise. Compare the two commands side by side.
return {
  goal = 'Swap the two words using very magic syntax instead of escaped groups',
  hint = 'Two characters at the start of the pattern change the whole dialect.',
  start = { 'john smith' },
  cursor = { 1, 0 },
  want = { 'smith, john' },
  keys = ':s/\\v(\\w+) (\\w+)/\\2, \\1/<CR>',
}
