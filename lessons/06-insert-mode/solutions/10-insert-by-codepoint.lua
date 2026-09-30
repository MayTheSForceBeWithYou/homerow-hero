-- Drill 10. Insert a character by its Unicode code point rather than by finding the
-- key. 0041 is capital A.
return {
  goal = 'Insert the character at code point 0041 without typing the letter',
  hint = 'One key takes a literal or a code; prefix the number with u for Unicode.',
  start = { 'x' },
  cursor = { 1, 0 },
  want = { 'Ax' },
  keys = 'i<C-v>u0041<Esc>',
}
