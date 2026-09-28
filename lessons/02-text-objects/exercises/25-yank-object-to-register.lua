-- Drill 25. Objects compose with every operator, not just `d`. Yank the argument
-- list into register q, leaving the buffer untouched.
return {
  goal = 'Yank the parenthesised contents into register q without changing the buffer',
  start = { 'foo(bar, baz)' },
  cursor = { 1, 8 },
  want = { 'foo(bar, baz)' },
  want_registers = { q = 'bar, baz' },
  keys = '', -- <- your answer
}
