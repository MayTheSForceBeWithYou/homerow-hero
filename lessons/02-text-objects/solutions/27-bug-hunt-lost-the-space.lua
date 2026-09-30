return {
  goal = 'Delete "total" leaving the spaces on both sides of it',
  hint = 'One size takes a whitespace run with it. You want the other.',
  start = { 'local total = 1' },
  cursor = { 1, 7 },
  want = { 'local  = 1' },
  -- `aw` took the trailing space as well, collapsing "local total = 1" to
  -- "local = 1". `iw` is the word alone, which is what you want when something
  -- else is going to occupy the gap.
  keys = 'diw',
}
