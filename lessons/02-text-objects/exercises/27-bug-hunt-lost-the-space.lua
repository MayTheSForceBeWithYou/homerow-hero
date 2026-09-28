-- Drill 27. BUG HUNT -- starts FAILING. One letter is wrong.
--
-- The intent is to retype a variable name: delete `total` and leave the spacing
-- exactly as it is, so that `local total = 1` keeps both of its spaces. Run it and
-- look at what happened to the space before the `=`.
--
-- Both objects here are legal and neither errors. That is what makes this the
-- mistake people actually ship.
return {
  goal = 'Delete "total" leaving the spaces on both sides of it',
  hint = 'One size takes a whitespace run with it. You want the other.',
  start = { 'local total = 1' },
  cursor = { 1, 7 },
  want = { 'local  = 1' },
  keys = 'daw',
}
