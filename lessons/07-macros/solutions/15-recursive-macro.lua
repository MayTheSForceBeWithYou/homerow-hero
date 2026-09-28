-- Drill 15. A macro that calls itself loops until it fails. Two things are easy to
-- forget: the register must be empty before recording, so the recursive call is a
-- no-op while you record it; and recording is not running, so you must invoke it
-- afterwards.
--
-- `setup` clears the register. Record the macro -- ending with a call to itself --
-- and then start it.
return {
  goal = 'Record a self-calling prefix macro into r, then invoke it',
  hint = 'End the recording with @r, stop recording, then run it once.',
  start = { '1', '2', '3', '4' },
  cursor = { 1, 0 },
  want = { '-1', '-2', '-3', '-4' },
  setup = function()
    vim.fn.setreg('r', '')
  end,
  keys = 'qrI-<Esc>j@rq@r',
}
