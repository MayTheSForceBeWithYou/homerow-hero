-- Drill 08. The browser back button. Two jumps, then retrace one step.
return {
  goal = 'From line 3, jump to the last line, then to the first, then go back one jump',
  hint = 'Not a mark -- the jumplist.',
  start = { 'l1', 'l2', 'l3', 'l4', 'l5', 'l6' },
  cursor = { 3, 0 },
  want = { 'l1', 'l2', 'l3', 'l4', 'l5', 'l6' },
  want_cursor = { 6, 0 },
  setup = function()
    vim.cmd('clearjumps')
  end,
  keys = '', -- <- your answer
}
