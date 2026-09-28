-- Drill 08. A delete of less than one line never enters the numbered queue. Return
-- the register name -- one character -- where it goes instead.
return {
  goal = 'Return the register a sub-line delete writes to',
  hint = 'It is punctuation, not a digit.',
  check = function()
    vim.fn.setreg('1', 'SENTINEL\n')
    vim.fn.setreg('-', '')
    local b = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_set_current_buf(b)
    vim.api.nvim_buf_set_lines(b, 0, -1, false, { 'alpha beta' })
    vim.api.nvim_win_set_cursor(0, { 1, 0 })
    vim.api.nvim_feedkeys('diw', 'mtx', false)

    local answer = '-' -- <- your answer
    assert(answer ~= nil, 'DRILL_TODO')
    assert(
      vim.fn.getreg(answer) == 'alpha',
      ('register %q holds %q'):format(answer, vim.fn.getreg(answer))
    )
    -- And confirm the numbered queue was genuinely left alone.
    assert(
      vim.fn.getreg('1') == 'SENTINEL\n',
      'the numbered register was overwritten -- a small delete should not touch it'
    )
  end,
}
