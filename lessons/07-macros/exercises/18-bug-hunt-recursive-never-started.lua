-- Drill 18. BUG HUNT -- starts FAILING.
--
-- The intent is a recursive macro: prefix every line with "-", looping until it runs
-- off the end of the buffer. The register was cleared, the recursive call was
-- recorded, and the recording is correct.
--
-- Run it: only the first line changed. Something that has to happen after recording
-- did not happen.
return {
  goal = 'Record a self-calling prefix macro into r and have it process every line',
  hint = 'Recording a macro is not the same as running it.',
  start = { '1', '2', '3', '4' },
  cursor = { 1, 0 },
  want = { '-1', '-2', '-3', '-4' },
  setup = function()
    vim.fn.setreg('r', '')
  end,
  keys = 'qrI-<Esc>j@rq',
}
