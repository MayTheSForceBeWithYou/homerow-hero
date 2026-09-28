-- Drill 05. Lowercase respects punctuation. Delete only "method", leaving the
-- dot and the call intact.
return {
  goal = 'Delete "method" but not the dot or the parentheses',
  start = { 'call obj.method(x)' },
  cursor = { 1, 10 },
  want = { 'call obj.(x)' },
  keys = 'diw',
}
