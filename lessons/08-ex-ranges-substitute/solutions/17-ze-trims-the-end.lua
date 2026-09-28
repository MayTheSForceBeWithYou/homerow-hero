-- Drill 17. The mirror image: replace only "foo", but only when "bar" follows it.
return {
  goal = 'Replace only "foo" with X, requiring "bar" after it',
  start = { 'foobar' },
  cursor = { 1, 0 },
  want = { 'Xbar' },
  keys = ':s/foo\\zebar/X/<CR>',
}
