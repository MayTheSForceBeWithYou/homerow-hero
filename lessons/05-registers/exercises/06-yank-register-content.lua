-- Drill 06. Read the registers directly rather than through a paste. After a yank
-- and then a linewise delete, return the contents of the yank register.
--
-- Note the absence of a trailing newline: `yiw` captures a word, charwise.
return {
  goal = 'Return the yank register contents after a yank followed by a delete',
  check = function()
    vim.fn.setreg('0', '')
    vim.fn.setreg('1', '')
    local b = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_set_current_buf(b)
    vim.api.nvim_buf_set_lines(b, 0, -1, false, { 'alpha beta', 'gamma' })
    vim.api.nvim_win_set_cursor(0, { 1, 0 })
    vim.api.nvim_feedkeys('yiwjdd', 'mtx', false)

    local answer = nil -- <- your answer
    assert(answer ~= nil, 'DRILL_TODO')
    assert(
      answer == 'alpha',
      ('the yank register holds %q; you returned %q'):format(vim.fn.getreg('0'), tostring(answer))
    )
  end,
}
