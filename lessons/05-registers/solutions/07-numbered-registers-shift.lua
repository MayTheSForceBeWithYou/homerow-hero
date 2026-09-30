-- Drill 07. Three linewise deletes in a row. Return the register name -- as the
-- single character you would type after a double quote -- that now holds the FIRST
-- line you deleted.
return {
  goal = 'Return the register holding the oldest of three consecutive linewise deletes',
  hint = 'Each new linewise delete pushes the queue down by one.',
  check = function()
    for i = 1, 9 do
      vim.fn.setreg(tostring(i), '')
    end
    local b = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_set_current_buf(b)
    vim.api.nvim_buf_set_lines(b, 0, -1, false, { 'L1', 'L2', 'L3', 'L4' })
    vim.api.nvim_win_set_cursor(0, { 1, 0 })
    vim.api.nvim_feedkeys('dddddd', 'mtx', false)

    local answer = '3' -- <- your answer
    assert(answer ~= nil, 'DRILL_TODO')
    assert(
      vim.fn.getreg(answer) == 'L1\n',
      ('register %q holds %q, not the first deleted line'):format(answer, vim.fn.getreg(answer))
    )
  end,
}
