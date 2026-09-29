-- Drill 10. With 'hidden' on, the same switch succeeds and the buffer becomes
-- *hidden* -- still loaded, still modified. Return true if both remain true of it.
return {
  goal = 'Return whether a hidden buffer stays both loaded and modified',
  check = function()
    vim.cmd('silent! only')
    vim.o.hidden = true
    vim.cmd('edit! zz_mod2.txt')
    vim.api.nvim_buf_set_lines(0, 0, -1, false, { 'MODIFIED' })
    local buf = vim.api.nvim_get_current_buf()
    vim.cmd('edit zz_other2.txt')

    -- TODO_GUARD

    local answer = vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].modified -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == true, 'a hidden buffer is still loaded and still modified')
    vim.bo[buf].modified = false
  end,
}
