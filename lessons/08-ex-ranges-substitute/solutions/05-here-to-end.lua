-- Drill 05. The other range worth memorising: from here to the end of the file.
return {
  goal = 'Replace "a" with X from the current line to the last line',
  start = { 'one a', 'two a', 'three a', 'four a', 'five a' },
  cursor = { 4, 0 },
  want = { 'one a', 'two a', 'three a', 'four X', 'five X' },
  keys = ':.,$s/a/X/<CR>',
}
