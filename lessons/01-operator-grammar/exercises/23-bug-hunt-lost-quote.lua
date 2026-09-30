-- Drill 23. BUG HUNT -- starts FAILING. One keystroke is wrong.
--
-- The intent is to replace the string's contents and leave both quotes standing.
-- Run it and read the `got` line: the closing quote has been eaten and replaced
-- by the typed text.
--
-- The operator is right. The motion is one letter away from right.
return {
  goal = 'Replace the text between the quotes, keeping both quotes',
  hint = 'One of the two forward-search motions takes the character it lands on.',
  start = { 'print("hello")' },
  cursor = { 1, 6 },
  want = { 'print("bye")' },
  keys = 'lcf"bye<Esc>',
}
