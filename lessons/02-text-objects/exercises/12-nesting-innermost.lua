-- Drill 12. With nesting and no count, the object is the innermost block
-- containing the cursor.
return {
  goal = 'Empty the innermost parentheses around the cursor',
  start = { 'a(b(c)d)e' },
  cursor = { 1, 4 },
  want = { 'a(b()d)e' },
  keys = '', -- <- your answer
}
