-- Drill 10. Same cursor, the `a` size: the parentheses go too.
return {
  goal = 'Delete the argument list including its parentheses',
  start = { 'foo(bar, baz)' },
  cursor = { 1, 8 },
  want = { 'foo' },
  keys = 'da(',
}
