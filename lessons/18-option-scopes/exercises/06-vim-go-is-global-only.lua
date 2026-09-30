-- Drill 06. And the mirror image: global only, local untouched.
return {
  goal = 'Return the local and global values after writing with vim.go',
  check = function()
    local b = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_set_current_buf(b)
    vim.api.nvim_set_option_value('shiftwidth', 8, { scope = 'global' })
    vim.api.nvim_set_option_value('shiftwidth', 8, { buf = b })

    vim.go.shiftwidth = 2

    local answer = nil -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer[1] == 8, 'the local must be untouched at 8')
    assert(answer[2] == 2, 'the global should be 2')
  end,
}
