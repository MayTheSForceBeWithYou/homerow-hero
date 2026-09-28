-- Drill 19. Marks compose with `y` as readily as with `d`. Yank lines 1 to 3
-- linewise into register q, leaving the buffer untouched.
--
-- Note the trailing newline in the expected register content: a linewise yank
-- always ends in one.
return {
  goal = 'Yank lines 1 through 3 linewise into register q using a mark',
  start = { 'aaa', 'bbb', 'ccc', 'ddd' },
  cursor = { 3, 0 },
  want = { 'aaa', 'bbb', 'ccc', 'ddd' },
  want_registers = { q = 'aaa\nbbb\nccc\n' },
  keys = 'magg"qy\'a',
}
