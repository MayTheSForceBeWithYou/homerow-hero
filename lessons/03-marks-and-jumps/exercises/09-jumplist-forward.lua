-- Drill 09. And forward again. Note that <C-i> is the same byte as <Tab> at a
-- terminal, which is why mapping <Tab> in Normal mode costs you this.
return {
  goal = 'Make two jumps, step back once, then step forward again',
  start = { 'l1', 'l2', 'l3', 'l4', 'l5', 'l6' },
  cursor = { 3, 0 },
  want = { 'l1', 'l2', 'l3', 'l4', 'l5', 'l6' },
  want_cursor = { 1, 0 },
  setup = function()
    vim.cmd('clearjumps')
  end,
  keys = '', -- <- your answer
}
