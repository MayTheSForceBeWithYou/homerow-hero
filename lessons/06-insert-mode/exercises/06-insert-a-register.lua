-- Drill 06. Pull a register's contents into the text you are typing, without
-- leaving Insert mode. Yank the first word, then open a line below and insert it.
return {
  goal = 'Yank the word, then insert it on a new line from within Insert mode',
  hint = 'One key reaches a register from Insert mode; the yank register is a digit.',
  start = { 'HI' },
  cursor = { 1, 0 },
  want = { 'HI', 'HI' },
  keys = '', -- <- your answer
}
