-- Drill 05. The contrast. `vim.bo` writes only the buffer's value, leaving the global
-- default alone -- which is what a per-filetype setting needs.
return {
  goal = 'Return the local and global values after writing with vim.bo',
  check = function()
    local b = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_set_current_buf(b)
    vim.api.nvim_set_option_value('shiftwidth', 8, { scope = 'global' })
    vim.api.nvim_set_option_value('shiftwidth', 8, { buf = b })

    vim.bo.shiftwidth = 2

    local answer = nil -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer[1] == 2, 'the local should be 2')
    assert(
      answer[2] == 8,
      ('the global must be untouched at 8, got %s'):format(tostring(answer[2]))
    )
  end,
}
