-- Drill 09. And with it.
return {
  goal = 'Replace every "a" on the line',
  start = { 'a a a' },
  cursor = { 1, 0 },
  want = { 'X X X' },
  keys = ':s/a/X/g<CR>',
}
