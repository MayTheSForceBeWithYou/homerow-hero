-- Drill 04. Record a macro into register q that prefixes a line with "-" and moves
-- down, then replay it once.
--
-- Remember that the recording pass performs the edit, so two lines change in total.
return {
  goal = 'Record a prefix-and-move macro into q, then replay it once',
  hint = 'q to start, q to stop, @ to play.',
  start = { '1', '2', '3' },
  cursor = { 1, 0 },
  want = { '-1', '-2', '3' },
  setup = function()
    vim.fn.setreg('q', '')
  end,
  keys = '', -- <- your answer
}
