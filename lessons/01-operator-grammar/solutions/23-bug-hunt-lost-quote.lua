return {
  goal = 'Replace the text between the quotes, keeping both quotes',
  hint = 'One of the two forward-search motions takes the character it lands on.',
  start = { 'print("hello")' },
  cursor = { 1, 6 },
  want = { 'print("bye")' },
  -- `f` is inclusive, so `cf"` consumed the closing quote as well. `t` stops
  -- before its target, leaving the quote in place.
  keys = 'lct"bye<Esc>',
}
