return {
  goal = 'Close the extra window while leaving the buffer loaded',
  hint = 'One command unloads text; the other closes a viewport onto it.',
  check = function()
    vim.cmd('silent! only')
    vim.o.hidden = true
    vim.cmd('edit zz_keepme.txt')
    local buf = vim.api.nvim_get_current_buf()
    vim.cmd('split')

    -- `:bdelete` unloads the BUFFER, and every window showing it then has to show
    -- something else -- or close. `:close` closes just this window and leaves the
    -- buffer loaded, which is what makes splits cheap.
    vim.cmd('close')

    assert(#vim.api.nvim_list_wins() == 1, 'the extra window should be gone')
    assert(
      vim.api.nvim_buf_is_loaded(buf),
      'the buffer should still be loaded -- closing a viewport must not unload text'
    )
  end,
}
