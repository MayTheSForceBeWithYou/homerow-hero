-- Drill 06. A `:ls` entry reading `line 0` has never been loaded. Add a buffer
-- without visiting it and return whether it is loaded.
return {
  goal = 'Return whether a buffer added but never visited is loaded',
  check = function()
    vim.cmd('silent! only')
    vim.cmd('badd zz_never_visited.txt')
    local nr = vim.fn.bufnr('zz_never_visited.txt')
    assert(nr ~= -1, 'the buffer should exist in the list')

    -- TODO_GUARD

    local answer = vim.api.nvim_buf_is_loaded(nr) -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == false, 'a buffer that was only :badd-ed is listed but not loaded')
    pcall(vim.cmd, 'bwipeout! ' .. nr)
  end,
}
