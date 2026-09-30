-- Drill 10. A one-command file reversal. `^` matches every line, and moving each
-- matched line to the top in turn inverts the order.
return {
  goal = 'Reverse the order of every line in the file with one command',
  hint = 'Match every line, and move each to the very top.',
  start = { '1', '2', '3', '4' },
  cursor = { 1, 0 },
  want = { '4', '3', '2', '1' },
  keys = ':g/^/m0<CR>',
}
