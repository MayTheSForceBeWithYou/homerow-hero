-- Drill 05. Same macro, replayed three times. Count the total: the recording pass
-- is repetition one.
return {
  goal = 'Record the prefix macro and replay it three times, changing four lines',
  start = { '1', '2', '3', '4', '5' },
  cursor = { 1, 0 },
  want = { '-1', '-2', '-3', '-4', '5' },
  setup = function()
    vim.fn.setreg('q', '')
  end,
  keys = 'qqI-<Esc>jq3@q',
}
