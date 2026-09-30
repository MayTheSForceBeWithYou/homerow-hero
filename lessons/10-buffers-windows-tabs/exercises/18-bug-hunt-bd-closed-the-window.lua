-- Drill 18. BUG HUNT -- starts FAILING.
--
-- The intent is to close the extra WINDOW created by the split, while leaving the
-- buffer loaded so you can come back to it.
--
-- Run it: the window did close, but the buffer was unloaded too. The command used
-- operates on the buffer, not on the viewport. Lesson 10's distinctions table has the
-- pair.
return {
  goal = 'Close the extra window while leaving the buffer loaded',
  hint = 'One command unloads text; the other closes a viewport onto it.',
  check = function()
    vim.cmd('silent! only')
    vim.o.hidden = true
    vim.cmd('edit zz_keepme.txt')
    local buf = vim.api.nvim_get_current_buf()
    vim.cmd('split')

    vim.cmd('bdelete')

    assert(#vim.api.nvim_list_wins() == 1, 'the extra window should be gone')
    assert(
      vim.api.nvim_buf_is_loaded(buf),
      'the buffer should still be loaded -- closing a viewport must not unload text'
    )
  end,
}
