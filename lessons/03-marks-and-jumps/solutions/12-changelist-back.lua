-- Drill 12. A different history from the jumplist. Edit two separate lines, move
-- away, then step back to the most recent edit.
return {
  goal = 'Append "!" to line 2 and "?" to line 5, go to line 1, then return to the latest change',
  hint = 'The jumplist is where you looked; you want where you edited.',
  start = { 'l1', 'l2', 'l3', 'l4', 'l5', 'l6' },
  cursor = { 1, 0 },
  want = { 'l1', 'l2!', 'l3', 'l4', 'l5?', 'l6' },
  want_cursor = { 5, 2 },
  keys = '2GA!<Esc>5GA?<Esc>ggg;',
}
