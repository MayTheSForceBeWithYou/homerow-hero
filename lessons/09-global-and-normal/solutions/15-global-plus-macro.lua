-- Drill 15. The payoff, combining lesson 07 and this one. `setup` puts a per-line
-- edit in register q -- note it has NO trailing `j`, because :g does the iterating.
--
-- Apply it to every line containing "todo".
return {
  goal = 'Run the macro in register q on every line containing "todo"',
  hint = ':g selects the lines, :normal types the keys, and @q is keys.',
  start = { 'todo one', 'skip', 'todo two', 'skip', 'todo three' },
  cursor = { 1, 0 },
  want = { '- todo one', 'skip', '- todo two', 'skip', '- todo three' },
  setup = function()
    vim.fn.setreg('q', 'I- \27')
  end,
  keys = ':g/todo/normal @q<CR>',
}
