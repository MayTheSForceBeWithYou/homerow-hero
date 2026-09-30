-- Drill 02. A window is a viewport, not the text. Split, then return true if both
-- windows are showing the SAME buffer.
return {
  goal = 'Return whether both windows after a split show the same buffer',
  check = function()
    vim.cmd('silent! only')
    vim.cmd('enew')
    vim.cmd('split')
    local wins = vim.api.nvim_list_wins()

    error('DRILL_TODO') -- delete this line once you have written your answer

    local answer = nil -- <- your answer

    assert(answer ~= nil, 'DRILL_TODO')
    assert(answer == true, 'a split shows the same buffer in both windows')
    vim.cmd('silent! only')
  end,
}
