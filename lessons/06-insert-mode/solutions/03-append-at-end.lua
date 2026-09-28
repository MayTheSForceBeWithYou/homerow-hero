-- Drill 03. Append to the end of the line from a cursor in the middle.
return {
  goal = 'Append a semicolon at the end of the line',
  start = { 'call_it()' },
  cursor = { 1, 2 },
  want = { 'call_it();' },
  keys = 'A;<Esc>',
}
