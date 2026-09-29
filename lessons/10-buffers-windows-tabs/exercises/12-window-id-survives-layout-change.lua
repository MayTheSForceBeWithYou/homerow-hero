-- Drill 12. Prove it. Record a window's id and its number, close another window so
-- the layout changes, then return whether the ID is still valid.
return {
  goal = 'Return whether a stored window ID is still valid after the layout changes',
  check = function()
    vim.cmd('silent! only')
    vim.cmd('enew')
    vim.cmd('split')
    vim.cmd('split')
    local id = vim.api.nvim_get_current_win()
    vim.cmd('wincmd j')
    vim.cmd('close')

    error('DRILL_TODO') -- delete this line once you have written your answer

    local answer = nil -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == true, 'a window ID stays valid while that window exists')
    vim.cmd('silent! only')
  end,
}
