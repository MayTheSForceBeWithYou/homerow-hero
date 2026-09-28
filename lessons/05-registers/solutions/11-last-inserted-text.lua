-- Drill 11. A read-only register you never filled deliberately. Return its name --
-- one character -- for the text you last typed in Insert mode.
return {
  goal = 'Return the register holding the text last typed in Insert mode',
  check = function()
    local b = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_set_current_buf(b)
    vim.api.nvim_buf_set_lines(b, 0, -1, false, { 'x' })
    vim.api.nvim_win_set_cursor(0, { 1, 0 })
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes('ihello <Esc>', true, false, true),
      'mtx',
      false
    )

    local answer = '.' -- <- your answer
    assert(answer ~= nil, 'DRILL_TODO')
    assert(
      vim.fn.getreg(answer) == 'hello ',
      ('register %q holds %q'):format(answer, vim.fn.getreg(answer))
    )
  end,
}
