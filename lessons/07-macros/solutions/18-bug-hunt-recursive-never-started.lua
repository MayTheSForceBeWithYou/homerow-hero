return {
  goal = 'Record a self-calling prefix macro into r and have it process every line',
  hint = 'Recording a macro is not the same as running it.',
  start = { '1', '2', '3', '4' },
  cursor = { 1, 0 },
  want = { '-1', '-2', '-3', '-4' },
  setup = function()
    vim.fn.setreg('r', '')
  end,
  -- The `@r` inside the recording ran the register while it was still empty, which
  -- is a no-op -- that is exactly why the register has to be cleared first. But
  -- recording is not running: the loop only begins when you invoke `@r` afterwards.
  keys = 'qrI-<Esc>j@rq@r',
}
