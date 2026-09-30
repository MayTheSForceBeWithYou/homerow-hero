-- Drill 09. Cursor on the "a" of "baz" -- deep inside, nowhere near a bracket.
return {
  goal = 'Delete the argument list contents, keeping the parentheses',
  start = { 'foo(bar, baz)' },
  cursor = { 1, 8 },
  want = { 'foo()' },
  keys = '', -- <- your answer
}
