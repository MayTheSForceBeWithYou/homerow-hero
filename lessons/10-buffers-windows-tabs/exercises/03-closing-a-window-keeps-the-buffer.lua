-- Drill 03. Closing a window never unloads a buffer -- which is what makes splits
-- cheap. Split, close the new window, and return whether the buffer is still loaded.
return {
  goal = 'Return whether a buffer stays loaded after its extra window is closed',
  hint = 'vim.api.nvim_buf_is_loaded tells you.',
  check = function()
    vim.cmd('silent! only')
    vim.cmd('enew')
    local buf = vim.api.nvim_get_current_buf()
    vim.cmd('split')
    vim.cmd('close')

    error('DRILL_TODO') -- delete this line once you have written your answer

    local answer = nil -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == true, 'closing a window must not unload the buffer')
    assert(#vim.api.nvim_list_wins() == 1, 'the window should be gone')
  end,
}
