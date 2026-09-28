-- Drill 13. Same cursor. A count climbs outward one nesting level per unit -- this
-- is how you reach an enclosing block without navigating to its bracket.
return {
  goal = 'Empty the outer parentheses from the same cursor position',
  hint = 'The count means "how many levels out", not "how many characters".',
  start = { 'a(b(c)d)e' },
  cursor = { 1, 4 },
  want = { 'a()e' },
  keys = '', -- <- your answer
}
