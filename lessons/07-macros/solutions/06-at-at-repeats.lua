-- Drill 06. `@@` replays whatever you replayed last, without naming the register
-- again.
return {
  goal = 'Record the prefix macro, replay it, then replay it again without naming q',
  hint = 'Two characters.',
  start = { '1', '2', '3' },
  cursor = { 1, 0 },
  want = { '-1', '-2', '-3' },
  setup = function()
    vim.fn.setreg('q', '')
  end,
  keys = 'qqI-<Esc>jq@q@@',
}
