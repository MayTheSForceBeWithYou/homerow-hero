-- Drill 05. The free mark you will use most. `G` is a jump, so the position you
-- left was recorded automatically -- no `m` needed. Get back to line 2.
return {
  goal = 'From line 2, jump to the last line, then return without having set a mark',
  hint = 'Doubling the precise spelling means "before the latest jump".',
  start = { 'one', 'two', 'three', 'four', 'five' },
  cursor = { 2, 0 },
  want = { 'one', 'two', 'three', 'four', 'five' },
  want_cursor = { 2, 0 },
  setup = function()
    vim.cmd('clearjumps')
  end,
  keys = '', -- <- your answer
}
