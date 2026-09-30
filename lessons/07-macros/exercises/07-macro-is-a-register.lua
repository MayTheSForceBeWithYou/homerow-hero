-- Drill 07. A macro is not like a register -- it IS one. Return the contents of
-- register w after recording a macro into it.
--
-- The Escape you pressed is stored as a literal byte: "\27" in Lua.
return {
  goal = 'Return the register contents after recording I-<Esc>j into w',
  hint = 'Escape is one byte, not the five characters <Esc>.',
  check = function()
    vim.fn.setreg('w', '')
    local b = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_set_current_buf(b)
    vim.api.nvim_buf_set_lines(b, 0, -1, false, { '1', '2' })
    vim.api.nvim_win_set_cursor(0, { 1, 0 })
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes('qwI-<Esc>jq', true, false, true),
      'mtx',
      false
    )

    local answer = nil -- <- your answer
    assert(answer ~= nil, 'DRILL_TODO')
    assert(
      vim.fn.getreg('w') == answer,
      ('the register holds %q; you said %q'):format(vim.fn.getreg('w'), answer)
    )
  end,
}
