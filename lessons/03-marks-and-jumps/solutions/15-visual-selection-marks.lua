-- Drill 15. `'<` and `'>` survive after you leave Visual mode, which is what makes
-- `:'<,'>` work in lesson 08. Select two lines linewise, leave Visual mode, and
-- return the START mark as a {line, col} pair.
return {
  goal = "Return the '< mark after a linewise selection of lines 2 and 3",
  run = function()
    vim.cmd('enew!')
    vim.api.nvim_buf_set_lines(0, 0, -1, false, { 'l1', 'l2', 'l3', 'l4' })
    vim.api.nvim_win_set_cursor(0, { 2, 0 })
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes('Vj<Esc>', true, false, true),
      'mtx',
      false
    )

    return vim.api.nvim_buf_get_mark(0, '<') -- <- your answer
  end,
  value = { 2, 0 },
}
