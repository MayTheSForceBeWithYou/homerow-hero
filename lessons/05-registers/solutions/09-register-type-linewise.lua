-- Drill 09. `getregtype()` reports a register's type in one character. Return what
-- it reports for the unnamed register after a linewise yank.
return {
  goal = 'Return the type character getregtype() reports after yy',
  hint = 'Charwise and linewise differ only in case.',
  check = function()
    local b = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_set_current_buf(b)
    vim.api.nvim_buf_set_lines(b, 0, -1, false, { 'A', 'B' })
    vim.api.nvim_win_set_cursor(0, { 1, 0 })
    vim.api.nvim_feedkeys('yy', 'mtx', false)

    local answer = 'V' -- <- your answer
    assert(answer ~= nil, 'DRILL_TODO')
    local actual = vim.fn.getregtype('"')
    assert(actual == answer, ('getregtype reported %q; you said %q'):format(actual, answer))
  end,
}
