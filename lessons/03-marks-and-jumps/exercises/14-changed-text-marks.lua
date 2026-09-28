-- Drill 14. `'[` and `']` bracket the last changed or yanked text. Yank one whole
-- line, then return the END mark's column.
--
-- The value will not be a small number. The lesson names what it is; return the
-- variable that holds it rather than typing the digits.
return {
  goal = "Return the column of the '] mark after yanking a whole line",
  hint = 'A mark covering a whole line uses a sentinel column, not a real one.',
  check = function()
    vim.cmd('enew!')
    vim.api.nvim_buf_set_lines(0, 0, -1, false, { 'yank this line', 'other' })
    vim.api.nvim_win_set_cursor(0, { 1, 0 })
    vim.api.nvim_feedkeys('yy', 'mtx', false)

    local answer = nil -- <- your answer
    assert(answer ~= nil, 'DRILL_TODO')
    local mark_end = vim.api.nvim_buf_get_mark(0, ']')
    assert(
      answer == mark_end[2],
      ("the '] mark's column is %d; you said %s"):format(mark_end[2], tostring(answer))
    )
  end,
}
