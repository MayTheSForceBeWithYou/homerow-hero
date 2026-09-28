-- Drill 15. Same multi-line block, the `a` size -- braces included.
return {
  goal = 'Delete the whole brace block including the braces',
  start = { 'f = {', '  a = 1,', '  b = 2,', '}' },
  cursor = { 1, 4 },
  want = { 'f = ' },
  keys = '', -- <- your answer
}
